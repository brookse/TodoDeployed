Sequel.migration do
	up do
		create_table(:tasks) do
			primary_key :id
			String :task
			Boolean :complete
		end
	end

	down do
		drop_table(:tasks)
	end
end