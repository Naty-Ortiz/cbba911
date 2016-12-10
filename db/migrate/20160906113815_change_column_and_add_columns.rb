class ChangeColumnAndAddColumns < ActiveRecord::Migration
  def change
    add_column :complains, :ruralArea, :boolean
    add_column :complains,:provinceName, :string
    add_column :complains, :registrationDate, :date
    add_column :complains, :registrationHour, :time
    add_column :complains, :complainNumber, :string
    add_column :complains, :complainPlace, :string
    add_column :complains, :derivationCase, :string

    create_table :complainsAux do |t|
      t.string :numeroDenuncia
      t.time :hora
      t.date :fecha
      t.string :nombreOperador
      t.integer :nroTelefono
      t.string :lugarDenuncia
      t.string :operador
      t.string :nombreDenunciante
      t.string :contravencion
      t.string :delito
      t.string :zonaUrbana
      t.string :zonaRural
      t.string :direccion
      t.string :descripcionHecho
      t.string :unidadAsignada
      t.string :reporteCaso
      t.string :protagonista
      t.string :breveInforme
      t.string :remisionCaso


      t.timestamps null: false
    end



    end
end
