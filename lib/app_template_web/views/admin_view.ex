defmodule AppTemplateWeb.AdminView do
  use AppTemplateWeb, :view
  @page_links_to_show 2

  def make_next_page_link(conn, current_page, url) do
    make_page_link(conn, current_page + 1, url)
  end

  def make_previous_page_link(conn, current_page, url) do
    make_page_link(conn, current_page - 1, url)
  end

  def make_page_link(conn, page, url) do
    query_params = conn.query_params

    query_params = Map.put(query_params, "page", page)

    uri = URI.parse(url)

    query_params =
      if is_nil(uri.query) do
        query_params
      else
        URI.decode_query(uri.query, query_params)
      end

    uri = %{uri | query: Plug.Conn.Query.encode(query_params)}

    URI.to_string(uri)
  end

  def first_page?(1), do: true
  def first_page?(_), do: false

  def last_page?(page_number, total_pages) when page_number == total_pages, do: true
  def last_page?(_, _), do: false

  def show_pagination?(1), do: false
  def show_pagination?(_), do: true

  def selected_page_class(page_number, current_page) when page_number == current_page do
    "rev-Pagination-number--selected"
  end

  def selected_page_class(_, _) do
    ""
  end

  def show_previous_ellipsis?(1, _) do
    false
  end

  def show_previous_ellipsis?(page, page_number) do
    page == page_number - @page_links_to_show
  end

  def show_next_ellipsis?(page, page_number, total_pages) do
    page == page_number + @page_links_to_show and page != total_pages
  end

  def show_page_link?(page, page_number) do
    page >= page_number - @page_links_to_show and page <= page_number + @page_links_to_show
  end

  def field(form, schema_module, field, opts \\ []) do
    case schema_module.__schema__(:type, field) do
      :boolean ->
        ~E"""
        <%= col do %>
          <%= single_checkbox(form, field, Keyword.merge([label: String.capitalize(to_string(field))], opts)) %>
        <% end %>
        """

      :integer ->
        ~E"""
        <%= col do %>
          <%= number_input_stack(
              form,
              field,
              label: String.capitalize(to_string(field)),
              input: Keyword.merge([placeholder: String.capitalize(to_string(field))], opts))
          %>
        <% end %>
        """

      _ ->
        ~E"""
        <%= col do %>
          <%= text_input_stack(
              form,
              field,
              label: String.capitalize(to_string(field)),
              input: Keyword.merge([placeholder: String.capitalize(to_string(field))], opts))
          %>
        <% end %>
        """
    end
  end

  def association(form, schema_module, association, opts \\ []) do
    association = schema_module.__schema__(:association, association)

    # make sure your schemas implement the `String.Chars` protocol so they can
    # look nice in a select!
    # obviously, if you have massive tables, `Repo.all/1` is a bad idea!
    options =
      AppTemplate.Repo.all(association.queryable)
      |> Enum.map(&{&1.id, to_string(&1)})

    case association.cardinality do
      :many ->
        ~E"""
        <%= col do %>
          <%= multiple_select_stack(
              form,
              association,
              options,
              Keyword.merge([label: String.capitalize(to_string(association))], opts))
          %>
        <% end %>
        """

      _ ->
        ~E"""
        <%= col do %>
          <%= select_stack(
              form,
              association,
              options,
              Keyword.merge([label: String.capitalize(to_string(association))], opts))
          %>
        <% end %>
        """
    end
  end
end
