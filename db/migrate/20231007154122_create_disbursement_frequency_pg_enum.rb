class CreateDisbursementFrequencyPgEnum < ActiveRecord::Migration[7.0]
  def up
    create_enum :disbursement_frequency, %w[WEEKLY DAILY]
  end

  def down
    execute <<-SQL
        DROP TYPE disbursement_frequency;
    SQL
  end
end
