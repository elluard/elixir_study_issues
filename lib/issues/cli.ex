defmodule Issues.CLI do
  @default_count 4
  @moduledoc """
  명령줄 파싱을 수행한 뒤, 각종 함수를 호출해
  깃허브 프로젝트의 최근 _n_개 이슈를 표 형식으로 만들어 출력한다.
  """
  def run(argv) do
    parse_args(argv)
  end

  @doc """
  'argv' 는 -h 또는 --help(이 경우 :help 를 반환)이거나,
  깃허브 사용자 이름, 프로젝트 이름, (선택적으로) 가져올 이슈 갯수여야 한다.any()
  '{ 사용자명, 프로젝트명, 이슈 개수}' 또는 :help를 반환한다.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [ h: :help ])
    |> elem(1)
    |> args_to_internal_representation()

    # case parse do
    #   { [help: true], _, _ } -> :help
    #   {_, [ user, project, count], _ } -> {user, project, String.to_integer(count)}
    #   {_, [user, project], _} -> {user, project, @default_count}
    #   _ -> :help
    # end
  end

  def args_to_internal_representation([user, project, count]) do
    { user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    { user, project, @default_count }
  end

  def args_to_internal_representation(_) do #잘못된 인자 또는 --help
    :help
  end
end