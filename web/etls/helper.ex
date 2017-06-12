defmodule DotaLust.ETL.Helper do
  @spec raw_value(any) :: integer
  def raw_value(enum) do
    if enum do
      enum.value.value
    end
  end
end
