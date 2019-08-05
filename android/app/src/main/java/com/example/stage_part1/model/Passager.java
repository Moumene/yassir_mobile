package com.example.stage_part1.model;

import android.os.Parcel;
import android.os.Parcelable;

public class Passager {

    private String name;
    private String surname;
    private float rating;
    private int imageSrc;



    private String numTel;

    public Passager(String name, String surname, float rating, int imageSrc, String numTel) {
        this.name = name;
        this.surname = surname;
        this.rating = rating;
        this.imageSrc = imageSrc;
        this.numTel = numTel;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public String getSurname() {
        return surname;
    }
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public void setSurname(String surname) {
        this.surname = surname;
    }


    public int getImageSrc() {
        return imageSrc;
    }

    public void setImageSrc(int imageSrc) {
        this.imageSrc = imageSrc;
    }

    public String getNumTel() {
        return numTel;
    }

    public void setNumTel(String numTel) {
        this.numTel = numTel;
    }

}
