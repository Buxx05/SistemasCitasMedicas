package model;

public class RecetaMedica {

    private int idReceta;
    private int idCita;
    private int idProfesional;
    private int idPaciente;
    private String fechaEmision;
    private String indicaciones;
    private String medicamentos;
    private String dosis;
    private String frecuencia;
    private String duracion;
    private String fechaVigencia;
    private String observaciones;

    // ✅ AGREGAR: Atributos para códigos
    private String codigoReceta;
    private String codigoCita;
    private String codigoPaciente;

    // Campos adicionales para JOINs (vistas)
    private String nombrePaciente;
    private String dniPaciente;
    private String nombreProfesional;
    private String nombreEspecialidad;
    private String fechaCita;
    private String horaCita;
    private String motivoConsulta;

    // Constructor vacío
    public RecetaMedica() {
    }

    // Constructor con campos principales
    public RecetaMedica(int idCita, int idProfesional, int idPaciente,
            String medicamentos, String dosis, String frecuencia) {
        this.idCita = idCita;
        this.idProfesional = idProfesional;
        this.idPaciente = idPaciente;
        this.medicamentos = medicamentos;
        this.dosis = dosis;
        this.frecuencia = frecuencia;
    }

    // Getters y Setters

    public int getIdReceta() {
        return idReceta;
    }

    public void setIdReceta(int idReceta) {
        this.idReceta = idReceta;
    }

    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public int getIdProfesional() {
        return idProfesional;
    }

    public void setIdProfesional(int idProfesional) {
        this.idProfesional = idProfesional;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public String getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(String fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    public String getIndicaciones() {
        return indicaciones;
    }

    public void setIndicaciones(String indicaciones) {
        this.indicaciones = indicaciones;
    }

    public String getMedicamentos() {
        return medicamentos;
    }

    public void setMedicamentos(String medicamentos) {
        this.medicamentos = medicamentos;
    }

    public String getDosis() {
        return dosis;
    }

    public void setDosis(String dosis) {
        this.dosis = dosis;
    }

    public String getFrecuencia() {
        return frecuencia;
    }

    public void setFrecuencia(String frecuencia) {
        this.frecuencia = frecuencia;
    }

    public String getDuracion() {
        return duracion;
    }

    public void setDuracion(String duracion) {
        this.duracion = duracion;
    }

    public String getFechaVigencia() {
        return fechaVigencia;
    }

    public void setFechaVigencia(String fechaVigencia) {
        this.fechaVigencia = fechaVigencia;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    // ✅ NUEVOS: Getters y Setters para códigos

    public String getCodigoReceta() {
        return codigoReceta;
    }

    public void setCodigoReceta(String codigoReceta) {
        this.codigoReceta = codigoReceta;
    }

    public String getCodigoCita() {
        return codigoCita;
    }

    public void setCodigoCita(String codigoCita) {
        this.codigoCita = codigoCita;
    }

    public String getCodigoPaciente() {
        return codigoPaciente;
    }

    public void setCodigoPaciente(String codigoPaciente) {
        this.codigoPaciente = codigoPaciente;
    }

    // Getters y Setters para campos de JOIN

    public String getNombrePaciente() {
        return nombrePaciente;
    }

    public void setNombrePaciente(String nombrePaciente) {
        this.nombrePaciente = nombrePaciente;
    }

    public String getDniPaciente() {
        return dniPaciente;
    }

    public void setDniPaciente(String dniPaciente) {
        this.dniPaciente = dniPaciente;
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

    public String getFechaCita() {
        return fechaCita;
    }

    public void setFechaCita(String fechaCita) {
        this.fechaCita = fechaCita;
    }

    public String getHoraCita() {
        return horaCita;
    }

    public void setHoraCita(String horaCita) {
        this.horaCita = horaCita;
    }

    public String getMotivoConsulta() {
        return motivoConsulta;
    }

    public void setMotivoConsulta(String motivoConsulta) {
        this.motivoConsulta = motivoConsulta;
    }

    @Override
    public String toString() {
        return "RecetaMedica{"
                + "idReceta=" + idReceta
                + ", codigoReceta='" + codigoReceta + '\''
                + ", idPaciente=" + idPaciente
                + ", idProfesional=" + idProfesional
                + ", fechaEmision='" + fechaEmision + '\''
                + ", medicamentos='" + medicamentos + '\''
                + '}';
    }
}
