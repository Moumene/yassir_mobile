package com.example.stage_part1.databinding;


import android.content.Context;
import android.databinding.BindingAdapter;
import android.widget.ImageView;




public class GlideBindingAdapter {

    private static final String TAG = "GlideBindingAdapters";


    @BindingAdapter("imageUrl")
    public static void setImage(ImageView view, int imageUrl){

        Context context = view.getContext();

    }
}
