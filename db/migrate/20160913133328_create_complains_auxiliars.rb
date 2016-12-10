class CreateComplainsAuxiliars < ActiveRecord::Migration
  def change
    create_table :complains_auxiliars do |t|
      t.string :numeroDenuncia
      t.string :hora
      t.string :fecha
      t.text :lugarDenuncia
      t.text :operador
      t.text :nombreOperador
      t.string :nroTelefono
      t.string :denunciante
      t.string :contravencion
      t.string  :delito
      t.string :ZonaUrbana
      t.string :zonaRural
      t.string :direccion
      t.text :descripcionHecho
      t.string :unidadAsignada
      t.text :reporteCaso
      t.text :protagonista
      t.text :breveInforme
      t.text :remisionCaso
    end
  end


end
