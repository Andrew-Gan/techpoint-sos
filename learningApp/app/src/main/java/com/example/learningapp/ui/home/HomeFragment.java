package com.example.learningapp.ui.home;

import android.app.ActionBar;
import android.graphics.Color;
import android.os.Bundle;
import android.util.AttributeSet;
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
        loadCoursesWIP(root);

        return root;
    }

    public void loadProfile(View root) {
        final TextView nameText = root.findViewById(R.id.home_name);
        final TextView majorText = root.findViewById(R.id.home_major);
        final TextView classText = root.findViewById(R.id.home_class);
        final TextView schoolText = root.findViewById(R.id.home_school);

        // to be replaced with data retrieval from database
        nameText.setText("Andrew");
        majorText.setText("Computer Engineering");
        classText.setText("Senior");
        schoolText.setText("Purdue University");
    }

    public void loadCoursesWIP(View root) {
        ConstraintLayout home_layout = root.findViewById(R.id.home_layout);
        // replace 3 with num courses retrieved from database
        String[] coursesName = {"ECE 201", "ENGL 106", "CS 301"};
//        ViewGroup[] wipcourses_view = new ViewGroup[coursesName.length];

        for(int i = 0; i < 3; i++) {
            // course name
            TextView courseText = new TextView(this.getContext());
            courseText.setX(100);
            courseText.setY(i * 100 + 725);
            courseText.setText(coursesName[i]);
            courseText.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 18);
            home_layout.addView(courseText);

            // drop button
            Button courseDropButton = new Button(this.getContext());
            RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(250, 100);
            courseDropButton.setX(450);
            courseDropButton.setY(i * 100 + 725 - 10);
            courseDropButton.setLayoutParams(rlp);
            courseDropButton.setText("DROP");
            courseDropButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
//            wipcourses_view[i].addView(courseDropButton);
            home_layout.addView(courseDropButton);

            // finish button
            Button courseFinishButton = new Button(this.getContext());
            courseFinishButton.setX(750);
            courseFinishButton.setY(i * 100 + 725 - 10);
            courseFinishButton.setLayoutParams(rlp);
            courseFinishButton.setText("FINISH");
            courseFinishButton.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, 12);
//            wipcourses_view[i].addView(courseFinishButton);
//            home_layout.addView(wipcourses_view[i]);
            home_layout.addView(courseFinishButton);
        }
    }
}