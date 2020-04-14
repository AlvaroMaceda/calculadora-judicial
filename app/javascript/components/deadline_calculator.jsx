import React, { Component, Fragment } from "react";
import Autocomplete from "./autocomplete";

function DeadlineCalculator(){
    return (
        <div>
          <h1>React Autocomplete Demo</h1>
          <h2>Start typing and experience the autocomplete wizardry!</h2>
          <Autocomplete
            suggestions={[
              "Alligator",
              "Bask",
              "Crocodilian",
              "Death Roll",
              "Eggs",
              "Jaws",
              "Reptile",
              "Solitary",
              "Tail",
              "Wetlands"
            ]}
          />
        </div>
      );
}

export default DeadlineCalculator;