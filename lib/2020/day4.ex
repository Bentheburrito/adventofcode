defmodule AOC.Day4 do
	@eye_colors ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

	def run(input) do
		passports = String.split(input, "\n\n")

		valid = AOC.time(&valid_passports/1, [passports])
		IO.puts "There are #{valid} valid passports."
		data_valid = AOC.time(&data_valid_passports/1, [passports])
		IO.puts "There are #{data_valid} data-valid passports."
	end

	def valid_passports(passports) do
		filter_and_count_passports(passports, fn
			(%{"byr" => _, "iyr" => _, "eyr" => _, "hgt" => _, "hcl" => _, "ecl" => _, "pid" => _}, count) -> count + 1
			(_, count) -> count
		end)
	end

	def data_valid_passports(passports) do
		filter_and_count_passports(passports, fn
			(%{"byr" => byr, "iyr" => iyr, "eyr" => eyr, "hgt" => {height, suffix}, "hcl" => hcl, "ecl" => ecl, "pid" => pid}, count)
			when ((suffix == "cm" and height in 150..193) or (suffix == "in" and height in 59..76)) and byr >= 1920 and byr <= 2002 and iyr >= 2010 and iyr <= 2020 and eyr >= 2020 and eyr <= 2030 and ecl in @eye_colors	->
				if (String.match?(hcl, ~r/^#[0-9a-f]{6}$/) and String.match?(pid, ~r/^[0-9]{9}$/)) do
					count + 1
				else
					count
				end
			(_, count) ->
				count
		end)
	end

	defp filter_and_count_passports(passports, filter_fn) do
		passports
		|> Enum.map(fn raw_passports ->
			String.split(raw_passports, ["\s", "\n"])
			|> Enum.into(%{}, fn
				"hcl:" <> val ->
					{"hcl", val}
				"pid:" <> val ->
					{"pid", val}
				<<key::24>> <>":"<> val ->
					case Integer.parse(val) do
						{num, ""} -> {<<key::24>>, num}
						:error -> {<<key::24>>, val}
						new_val -> {<<key::24>>, new_val}
					end
			end)
		end)
		|> Enum.reduce(0, filter_fn)
	end
end
