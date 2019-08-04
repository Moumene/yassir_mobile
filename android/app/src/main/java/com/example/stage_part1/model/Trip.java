package com.example.stage_part1.model;

import java.util.Calendar;

public class Trip {
    private Passager passager;
    private Calendar dateheureTrip;
    private String sourceName;
    private String sourceAdr;
    private String destinationName;
    private String destinationAdr;
    private long montant;
    private String id_course;

    public Trip(Passager passager, Calendar dateheureTrip, String sourceName, String sourceAdr, String destinationName, String destinationAdr, long montant, String id_course) {
        this.passager = passager;
        this.dateheureTrip = dateheureTrip;
        this.sourceName = sourceName;
        this.sourceAdr = sourceAdr;
        this.destinationName = destinationName;
        this.destinationAdr = destinationAdr;
        this.montant = montant;
        this.id_course = id_course;
    }


    public long getMontant() {
        return montant;
    }

    public void setMontant(long montant) {
        this.montant = montant;
    }

    public String getId_course() {
        return id_course;
    }

    public void setId_course(String id_course) {
        this.id_course = id_course;
    }

    public Passager getPassager() {
        return passager;
    }

    public void setPassager(Passager passager) {
        this.passager = passager;
    }

    public Calendar getDateheureTrip() {
        return dateheureTrip;
    }

    public void setDateheureTrip(Calendar dateheureTrip) {
        this.dateheureTrip = dateheureTrip;
    }

    public String getSourceName() {
        return sourceName;
    }

    public void setSourceName(String sourceName) {
        this.sourceName = sourceName;
    }

    public String getSourceAdr() {
        return sourceAdr;
    }

    public void setSourceAdr(String sourceAdr) {
        this.sourceAdr = sourceAdr;
    }

    public String getDestinationName() {
        return destinationName;
    }

    public void setDestinationName(String destinationName) {
        this.destinationName = destinationName;
    }

    public String getDestinationAdr() {
        return destinationAdr;
    }

    public void setDestinationAdr(String destinationAdr) {
        this.destinationAdr = destinationAdr;
    }
}
