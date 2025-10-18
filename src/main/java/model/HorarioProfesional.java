package model;

public class HorarioProfesional {

    private int idHorario;
    private int idProfesional;
    private String diaSemana;
    private String horaInicio;
    private String horaFin;
    private int duracionConsulta; // ← Nuevo campo
    private boolean activo;
    private String fechaCreacion; // ← Nuevo campo

    // Campos adicionales para vistas (JOIN)
    private String nombreProfesional;
    private String nombreEspecialidad;

    public HorarioProfesional() {
    }

    public HorarioProfesional(int idHorario, int idProfesional, String diaSemana, String horaInicio, String horaFin) {
        this.idHorario = idHorario;
        this.idProfesional = idProfesional;
        this.diaSemana = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
    }

    // Getters y Setters
    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public int getIdProfesional() {
        return idProfesional;
    }

    public void setIdProfesional(int idProfesional) {
        this.idProfesional = idProfesional;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(String horaFin) {
        this.horaFin = horaFin;
    }

    public int getDuracionConsulta() {
        return duracionConsulta;
    }

    public void setDuracionConsulta(int duracionConsulta) {
        this.duracionConsulta = duracionConsulta;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getNombreProfesional() {
        return nombreProfesional;
    }

    public void setNombreProfesional(String nombreProfesional) {
        this.nombreProfesional = nombreProfesional;
    }

    public String getNombreEspecialidad() {
        return nombreEspecialidad;
    }

    public void setNombreEspecialidad(String nombreEspecialidad) {
        this.nombreEspecialidad = nombreEspecialidad;
    }
}
