class Product < ActiveRecord::Base
	# attr_accessible :image_url
	# Para dar acceso al directorio donde este nuestro rails
	# /proyecto_rails/public/photo_store
	FOTOS = File.join Rails.root, 'app','assets','images', 'photo_store'
	# Metodo para ejecutar acciones despues de haber
	# guardado la información en la bd

	# El nombre de este metodo debe coincidir con el de image_url
	after_save :guardar_imagen

	def image_url=(file_data)
		#Se ejecuta solo si no esta vacio
		unless file_data.blank?
			@file_data = file_data
			#Parte el archivo en 2 por el caracter '.' y coge la ultima parte
			# para luego convertirlo a minuscula
			self.extension = file_data.original_filename.split('.').last.downcase
		end
	end

	# Ej. /rails_project/public/photo_store/23.png
	def imagen_filename
		File.join FOTOS, "#{id}.#{extension}"
	end

	# Ruta base, para poder acceder a las imagenes
	def imagen_path
		"photo_store/#{id}.#{extension}"
	end
	#Verifica si el archivo existe
	def has_imagen?
		File.exists?
	end
	private

	def guardar_imagen
		# Corroboramos que exista este objeto
		if @file_data
			#FileUtils, clase encarga de crear y manipular archivos en rails
			#Accedemos al directorio Fotos o en caso no existiera
			# se creara y accedera
			FileUtils.mkdir_p FOTOS
			File.open(imagen_filename, 'wb') do |f|
				f.write(@file_data.read)
			end
			#Liberamos esta variable
			@file_data = nil
		end
	end
end
