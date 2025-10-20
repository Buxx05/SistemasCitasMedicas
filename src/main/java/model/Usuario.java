package model;

import util.GeneradorCodigos;

public class Usuario {

    private int idUsuario;
    private String nombreCompleto;
    private String email;
    private String password;
    private int idRol;
    private String fechaRegistro;
    private boolean activo;
    private String dni;
    private String telefono;
    private String direccion;
    // ========== NUEVOS CAMPOS ==========
    private String fotoPerfil;           // Nombre del archivo
    private String biografia;            // Descripción personal
    private String fechaActualizacion;   // Última actualización

    // Campos adicionales para profesionales (si aplica)
    private String biografiaProfesional;  // Descripción profesional
    private int aniosExperiencia;
    // Atributo adicional para la vista
    private String nombreRol;

    private String codigoUsuario;

    // Constructor vacío
    public Usuario() {
    }

    // Getters
    public int getIdUsuario() {
        return idUsuario;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public int getIdRol() {
        return idRol;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public boolean isActivo() {
        return activo;
    }

    // Setters
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }

    public String getBiografia() {
        return biografia;
    }

    public void setBiografia(String biografia) {
        this.biografia = biografia;
    }

    public String getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(String fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    public String getBiografiaProfesional() {
        return biografiaProfesional;
    }

    public void setBiografiaProfesional(String biografiaProfesional) {
        this.biografiaProfesional = biografiaProfesional;
    }

    public int getAniosExperiencia() {
        return aniosExperiencia;
    }

    public void setAniosExperiencia(int aniosExperiencia) {
        this.aniosExperiencia = aniosExperiencia;
    }

    public String getCodigoUsuario() {
        if (codigoUsuario == null && idUsuario > 0 && idRol > 0) {
            codigoUsuario = GeneradorCodigos.generarCodigoUsuario(idRol, idUsuario);
        }
        return codigoUsuario;
    }

    public void setCodigoUsuario(String codigoUsuario) {
        this.codigoUsuario = codigoUsuario;
    }
}
