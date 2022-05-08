defmodule Issues.TableFormatter do
  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  @doc """
    표의 각 행 될 맵의 리스트와 헤더의 리스트를 받아,
    각 행에서 헤를 기준으로 데이터를 식별해 표준 출력으로 표를 표시한다.
    즉, 각 헤는 표의 열이 되며, 이ㄹ 이용해 각 행에서 필드의 값을 추출해 출력한다.

    각 열의 가 길이는 해당 열의 가장 긴 값에 맞도록 계산한다.
  """
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
      column_widths = width_of(data_by_columns),
      format = format_for(column_widths)
      do
        puts_one_line_in_columns(headers, format)
        IO.puts(separator(column_widths))
        puts_in_columns(data_by_columns, format)
      end
  end

  @doc """
  각 행이 키-값 쌍으로 이루어진 리스트일 때, 이 행의 리스트를 받아
  각 필드의 값만으로 이루어진 리스트를 반환한다.
  'header' 파라미터는 추출할 필드(열) 이 담긴 리스트다.

  ## 사용 예
    iex> list = [ Enum.into([{"a","1"}, {"b", "2"}, {"c", "3"}], %{}),
    ...>          Enum.into([{"a","4"}, {"b", "5"}, {"c", "6"}], %{})]
    iex> Issues.TableFormatter.split_into_columns(list, ["a", "b", "c"])
    [["1", "4"], ["2","5"], ["3","6"]]

  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
    파라미터를 바이너리(문자열) 로 변환해 반환한다.

    ## 사용 예
      iex> Issues.TableFormatter.printable("a")
      "a"
      iex> Issues.TableFormatter.printable(99)
      "99"
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def width_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, "|", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
