package model;

import util.GeneradorCodigos;

public class Paciente {

    private int idPaciente;
    private String nombreCompleto;
    private String dni;
    private String fechaNacimiento;
    private String genero;
    private String direccion;
    private String telefono;
    private String email;
    private String fechaRegistro;
    // Campos adicionales (no en BD, solo para mostrar en JSP)
    private String ultimaCita;        // Fecha de última cita
    private int totalCitas;            // Total de citas con este profesional
    private int citasCompletadas;      // Citas completadas
    private String codigoPaciente;
    private int edad;

    public Paciente() {
    }

    public Paciente(int idPaciente, String nombreCompleto, String dni, String fechaNacimiento, String genero) {
        this.idPaciente = idPaciente;
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.fechaNacimiento = fechaNacimiento;
        this.genero = genero;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(String fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getUltimaCita() {
        return ultimaCita;
    }

    public void setUltimaCita(String ultimaCita) {
        this.ultimaCita = ultimaCita;
    }

    public int getTotalCitas() {
        return totalCitas;
    }

    public void setTotalCitas(int totalCitas) {
        this.totalCitas = totalCitas;
    }

    public int getCitasCompletadas() {
        return citasCompletadas;
    }

    public void setCitasCompletadas(int citasCompletadas) {
        this.citasCompletadas = citasCompletadas;
    }

    // Getter con generación automática
    public String getCodigoPaciente() {
        if (codigoPaciente == null && idPaciente > 0) {
            codigoPaciente = GeneradorCodigos.generarCodigoPaciente(idPaciente);
        }
        return codigoPaciente;
    }

    public void setCodigoPaciente(String codigoPaciente) {
        this.codigoPaciente = codigoPaciente;
    }

    public int getEdad() {
        return edad;
    }

    public void setEdad(int edad) {
        this.edad = edad;
    }
}
