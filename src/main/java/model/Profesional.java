package model;

import util.GeneradorCodigos;

public class Profesional {

    private int idProfesional;
    private int idUsuario;
    private int idEspecialidad;
    private String numeroLicencia;
    private String telefono;
    private String nombreUsuario;
    private String emailUsuario;
    private String nombreEspecialidad;
    private String nombreRol;
    private boolean activo;

    // ✅ AGREGAR estos atributos
    private String biografiaProfesional;
    private int aniosExperiencia;

    private String codigoProfesional;
    private int idRol;

    public Profesional() {
    }

    public Profesional(int idProfesional, int idUsuario, int idEspecialidad, String numeroLicencia, String telefono) {
        this.idProfesional = idProfesional;
        this.idUsuario = idUsuario;
        this.idEspecialidad = idEspecialidad;
        this.numeroLicencia = numeroLicencia;
        this.telefono = telefono;
    }

    public int getIdProfesional() {
        return idProfesional;
    }

    public void setIdProfesional(int idProfesional) {
        this.idProfesional = idProfesional;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdEspecialidad() {
        return idEspecialidad;
    }

    public void setIdEspecialidad(int idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    public String getNumeroLicencia() {
        return numeroLicencia;
    }

    public void setNumeroLicencia(String numeroLicencia) {
        this.numeroLicencia = numeroLicencia;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getEmailUsuario() {
        return emailUsuario;
    }

    public void setEmailUsuario(String emailUsuario) {
        this.emailUsuario = emailUsuario;
    }

    public String getNombreEspecialidad() {
        return nombreEspecialidad;
    }

    public void setNombreEspecialidad(String nombreEspecialidad) {
        this.nombreEspecialidad = nombreEspecialidad;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
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

    public String getCodigoProfesional() {
        if (codigoProfesional == null && idProfesional > 0 && idRol > 0) {
            codigoProfesional = GeneradorCodigos.generarCodigoProfesional(idProfesional, idRol);
        }
        return codigoProfesional;
    }

    public void setCodigoProfesional(String codigoProfesional) {
        this.codigoProfesional = codigoProfesional;
    }

// Getter y Setter para idRol (si no lo tienes)
    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

}
