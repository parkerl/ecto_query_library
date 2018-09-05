defmodule FishingSpot.Doccer do
  def available? do
    ExDoc.Markdown.Earmark.available?
  end

  def to_html(text, opts) do
    options =
      struct(Earmark.Options,
        gfm: Keyword.get(opts, :gfm, true),
        line: Keyword.get(opts, :line, 1),
        file: Keyword.get(opts, :file),
        breaks: Keyword.get(opts, :breaks, false),
        smartypants: Keyword.get(opts, :smartypants, true),
        plugins: %{"query" => FishingSpot.Doccer})

    text |> Earmark.as_html!(options) |> ExDoc.Markdown.pretty_codeblocks()
  end

  def as_html(lines) do
    [{code, _}] = lines
    new_lines = [
      "```elixir",
      "iex> #{code}",
      "\n",
      code(code),
      "\n",
      sql(code),
      "\n",
      output(code),
      "```"
     ]
    {_, html, errors} = Earmark.as_html(new_lines)
    { Enum.join([html]), errors }
  end

  def query(code) do
    opts = [pretty: true, width: 0]
    {result, _} = Code.eval_string("Application.ensure_all_started(:fishing_spot); " <> code, [], __ENV__)
    inspect(result, opts)
  end

  def output(code) do
    opts = [pretty: true, limit: 5]
    {result, _} = Code.eval_string("Application.ensure_all_started(:fishing_spot); " <> code <> " |> FishingSpot.Repo.all", [], __ENV__)
    inspect(result, opts)
  end

  def sql(code) do
    {{result, _}, _} = Code.eval_string("Application.ensure_all_started(:fishing_spot); FishingSpot.Repo.to_sql(:all, " <> code <> ")", [], __ENV__)
    result
  end

  defp code(code) do
    [function | module_parts] = Module.split("Elixir." <> code) |> Enum.reverse
    module = Module.concat(Enum.reverse(module_parts))
    file_name = module.module_info[:compile][:source]

    file = File.stream!(file_name)
    |> Enum.drop_while(fn line -> !String.match?(line, Regex.compile!("def #{function}")) end)
    |> Enum.take_while(fn line -> String.trim(line) != "end"  end)
    |> Enum.drop(1)
    |> Enum.join
  end
end
