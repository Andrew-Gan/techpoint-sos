package com.example.learningapp.ui.home;

import android.app.ActionBar;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.Constraints;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.example.learningapp.R;

import java.util.jar.Attributes;

public class HomeFragment extends Fragment {

    private HomeViewModel homeViewModel;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        homeViewModel =
                ViewModelProviders.of(this).get(HomeViewModel.class);
        View root = inflater.inflate(R.layout.fragment_home, container, false);

        loadProfile(root);

        // replace 3 with num courses retrieved from database
        String[] coursesWIP = {"ECE 201", "ENGL 106", "CS 301", "ENGR 132"};
        createCoursesList(root, coursesWIP, 750, true);

        TextView recText = new TextView(this.getContext());
        recText.setText("Recommended courses");
        recText.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
        recText.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        ConstraintLayout home_layout = root.findViewById(R.id.home_layout);
        recText.setX(110);
        recText.setY(1080);
        home_layout.addView(recText);

        String[] coursesRec = {"ECE 301", "MGMT 101", "ECONS 252"};
        createCoursesList(root, coursesRec, 1200, false);

        return root;
    }

    public void loadProfile(View root) {
        final TextView nameText = root.findViewById(R.id.home_name);
        final TextView majorText = root.findViewById(R.id.home_major);
        final TextView classText = root.findViewById(R.id.home_class);
        final TextView schoolText = root.findViewById(R.id.home_school);

        // to be replaced with data retrieval from database
        String[] user_info = {"Andrew", "Economics", "Sophomore", "Florida University"};
        nameText.setText(user_info[0]);
        majorText.setText(user_info[1]);
        classText.setText(user_info[2]);
        schoolText.setText(user_info[3]);
    }

    public void createCoursesList(View root, String[] course_list, int y, Boolean inProg) {
        ConstraintLayout home_layout = root.findViewById(R.id.home_layout);
        RelativeLayout[] wip_courses_view = new RelativeLayout[course_list.length];
        for(int i = 0; i < course_list.length; i++) {
            // call constructor
            wip_courses_view[i] = new RelativeLayout(this.getContext());
            wip_courses_view[i].setMinimumWidth(900);

            // course name
            TextView courseText = new TextView(this.getContext());
            courseText.setText(course_list[i]);
            courseText.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 18);
            wip_courses_view[i].addView(courseText);

            RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(250, 100);
            if(inProg == true) {

                // drop button
                Button courseDropButton = new Button(this.getContext());
                courseDropButton.setX(300);
                courseDropButton.setY(-15);
                courseDropButton.setLayoutParams(rlp);
                courseDropButton.setText("DROP");
                courseDropButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
                wip_courses_view[i].addView(courseDropButton);

                // finish button
                Button courseFinishButton = new Button(this.getContext());
                courseFinishButton.setX(600);
                courseFinishButton.setY(-15);
                courseFinishButton.setLayoutParams(rlp);
                courseFinishButton.setText("FINISH");
                courseFinishButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
                wip_courses_view[i].addView(courseFinishButton);
            }
            else {
                // add button
                Button courseFinishButton = new Button(this.getContext());
                courseFinishButton.setX(300);
                courseFinishButton.setY(-15);
                courseFinishButton.setLayoutParams(rlp);
                courseFinishButton.setText("ADD");
                courseFinishButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
                wip_courses_view[i].addView(courseFinishButton);
            }

            // add course layout to home layout
            wip_courses_view[i].setX(120);
            wip_courses_view[i].setY(i * 75 + y);
            home_layout.addView(wip_courses_view[i]);
        }
    }
}