package com.soorinpark.soorinpark.beerbelly.model;

import com.google.gson.annotations.SerializedName;

/**
 * Created by soorinpark on 11/8/16.
 */

public class Brewery {

    @SerializedName("name")
    private String name;
    @SerializedName("streetAddress")
    private String street;
    @SerializedName("locality")
    private String city;
    @SerializedName("region")
    private String state;
    @SerializedName("postalCode")
    private String zipcode;
    @SerializedName("phone")
    private String phone;
    @SerializedName("website")
    private String website;
    @SerializedName("latitude")
    private Double latitude;
    @SerializedName("longitude")
    private Double longitude;
    @SerializedName("breweryId")
    private String breweryId;
    @SerializedName("brewery")
    private Brewery brewery;

    public Brewery(String name, String street, String city, String state,
                   String zipcode, String phone, String website,
                   Double latitude, Double longitude, String breweryId, Brewery brewery) {
        this.name = name;
        this.street = street;
        this.city = city;
        this.state = state;
        this.zipcode = zipcode;
        this.phone = phone;
        this.website = website;
        this.latitude = latitude;
        this.longitude = longitude;
        this.breweryId = breweryId;
        this.brewery = brewery;
    }

    public String getName() {
        return name;
    }

    public String getStreet() {
        return street;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public String getZipcode() {
        return zipcode;
    }

    public String getPhone() {
        return phone;
    }

    public String getWebsite() { return website; }

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public String getBreweryId() { return breweryId; }

    public Brewery getBrewery() { return brewery; }

}
