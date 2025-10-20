package model;

/**
 * Clase que representa una Especialidad médica o no médica
 * en el sistema de gestión de citas
 */
public class Especialidad {
    
    // Atributos
    private int idEspecialidad;
    private String codigo;        // Código único (ej: CARD, PEDI, PSIC)
    private String nombre;        // Nombre de la especialidad
    private String descripcion;   // Descripción opcional

    // ========== CONSTRUCTORES ==========
    
    /**
     * Constructor vacío
     */
    public Especialidad() {
    }

    /**
     * Constructor con ID
     */
    public Especialidad(int idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    /**
     * Constructor sin ID (para insertar)
     */
    public Especialidad(String codigo, String nombre, String descripcion) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    /**
     * Constructor completo
     */
    public Especialidad(int idEspecialidad, String codigo, String nombre, String descripcion) {
        this.idEspecialidad = idEspecialidad;
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    // ========== GETTERS Y SETTERS ==========
    
    public int getIdEspecialidad() {
        return idEspecialidad;
    }

    public void setIdEspecialidad(int idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    // ========== MÉTODOS AUXILIARES ==========
    
    /**
     * Verifica si la especialidad tiene descripción
     */
    public boolean tieneDescripcion() {
        return descripcion != null && !descripcion.trim().isEmpty();
    }

    /**
     * Obtiene el código en mayúsculas
     */
    public String getCodigoMayusculas() {
        return codigo != null ? codigo.toUpperCase() : null;
    }

    // ========== MÉTODOS OVERRIDE ==========
    
    @Override
    public String toString() {
        return "Especialidad{" +
                "idEspecialidad=" + idEspecialidad +
                ", codigo='" + codigo + '\'' +
                ", nombre='" + nombre + '\'' +
                ", descripcion='" + descripcion + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Especialidad that = (Especialidad) o;
        return idEspecialidad == that.idEspecialidad;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(idEspecialidad);
    }
}
