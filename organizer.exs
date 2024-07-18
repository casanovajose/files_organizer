#!/usr/bin/env elixir

defmodule FileOrganizer do
  def run(args) do
    case args do
      [source_dir] -> create_directories_and_move_files(source_dir)
      _ -> IO.puts("Usage: organize_files.exs <source_directory>")
    end
  end

  defp create_directories_and_move_files(source_dir) do
    source_dir
    |> File.ls!()         # Obtener la lista de archivos en el directorio
    |> Enum.each(fn file ->
      case extract_lastname(file) do
        nil -> :ok        # Si no se puede extraer el apellido, no hacemos nada
        lastname -> move_file_to_directory(source_dir, lastname, file)
      end
    end)
  end

  defp extract_lastname(filename) do
    # Regex para extraer el apellido(s) antes del primer guión bajo
    regex = ~r/^([a-zA-Z_]+)_/
    case Regex.run(regex, filename) do
      [_, lastname] -> lastname
      _ -> nil
    end
  end

  defp move_file_to_directory(source_dir, lastname, file) do
    # Ruta del directorio objetivo
    target_dir = Path.join(source_dir, lastname)

    # Crear el directorio si no existe
    unless File.exists?(target_dir) do
      File.mkdir_p!(target_dir)
    end

    # Mover el archivo al nuevo directorio
    source_file = Path.join(source_dir, file)
    target_file = Path.join(target_dir, file)
    File.rename!(source_file, target_file)
  end
end

# Ejecutar el programa
FileOrganizer.run(System.argv())
