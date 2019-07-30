package com.example.stage_part1;


import android.app.DatePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.support.v7.widget.Toolbar;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class resaDetails extends AppCompatActivity {

    public static Context contextApp;

    public ImageButton alarmBtn;
    public static boolean isAlarmConfigured = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_resa_details);
        Toolbar toolbar = (Toolbar) findViewById(R.id.action_bar);

        toolbar.setTitle("Détails de la Réservation");

        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);

        alarmBtn = findViewById(R.id.bell_btn);

        contextApp = getApplicationContext();

    }



    public static Context getContextApp(){
        return contextApp;
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }



    public void Onclick_alarm(View v)
    {

        if (!isAlarmConfigured) {
            BottomSheetDialog bottomSheet = new BottomSheetDialog();
            bottomSheet.show(getSupportFragmentManager(),"BottomSheet");

        }
        else {

            LayoutInflater layoutInflater = LayoutInflater.from(this);
            View promptView = layoutInflater.inflate(R.layout.alert_promt, null);

            final AlertDialog.Builder alertDBuilder = new AlertDialog.Builder(this);
            final AlertDialog alertD = alertDBuilder.create();

            Button btn_supp_alarm = (Button) promptView.findViewById(R.id.btn_supp_alarm);
            Button btn_cancel_supp_alarm = (Button) promptView.findViewById(R.id.btn_cancel_supp_alarm);

            btn_supp_alarm.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    ImageButton imgbtn = findViewById(R.id.bell_btn);
                    imgbtn.setImageResource(R.drawable.baseline_notifications_white_24dp);
                    isAlarmConfigured = false;
                    alertD.cancel();
                }
            });

            btn_cancel_supp_alarm.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    alertD.cancel();
                }
            });

            alertD.setView(promptView);

            alertD.show();

        }

    }
    public void location_btn_1_click(View v)
    {
        Uri gmmIntentUri = Uri.parse("google.navigation:q=Alger");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        startActivity(mapIntent);
    }
    public void location_btn_2_click(View v)
    {
        Uri gmmIntentUri = Uri.parse("google.navigation:q=Bouismail");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        startActivity(mapIntent);
    }
    public void onClickCall(View v)
    {
        Intent callIntent = new Intent(Intent.ACTION_DIAL);
        callIntent.setData(Uri.parse("tel:0551573525"));
        startActivity(callIntent);

    }




}
