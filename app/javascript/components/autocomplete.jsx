import React, { Component, Fragment } from "react";
import PropTypes from "prop-types";
import style from './autocomplete.module.scss'

const UP_ARROW = 38
const DOWN_ARROW = 40
const KEY_ENTER = 13
const KEY_ESCAPE = 27

class Autocomplete extends Component {
  static propTypes = {
    suggestions: PropTypes.instanceOf(Array)
  };

  static defaultProps = {
    suggestions: []
  };

  constructor(props) {
    super(props);

    this.state = {
      // The active selection's index
      activeSuggestion: 0,
      // The suggestions that match the user's input
      filteredSuggestions: [],
      // Whether or not the suggestion list is shown
      showSuggestions: false,
      // What the user has entered
      userInput: ""
    };
  }

  // Event fired when the input value is changed
  onChange = e => {
    const { suggestions } = this.props;
    const userInput = e.currentTarget.value;

    // Filter our suggestions that don't contain the user's input
    const filteredSuggestions = suggestions.filter(
      suggestion =>
        suggestion.label.toLowerCase().indexOf(userInput.toLowerCase()) > -1
    );

    // Update the user input and filtered suggestions, reset the active
    // suggestion and make sure the suggestions are shown
    this.setState({
      activeSuggestion: 0,
      filteredSuggestions,
      showSuggestions: true,
      userInput: e.currentTarget.value
    });
  };

  // Event fired when the user clicks on a suggestion
  onClick = e => {
    // Update the user input and reset the rest of the state
    this.setState({
      activeSuggestion: 0,
      filteredSuggestions: [],
      showSuggestions: false,
      userInput: e.currentTarget.innerText
    });
  };

  // Event fired when the user presses a key down
  onKeyDown = e => {
    const { activeSuggestion, filteredSuggestions } = this.state;

    switch(e.keyCode) {
      case KEY_ESCAPE:
        break;
      case KEY_ENTER:
        this.setState({
          activeSuggestion: 0,
          showSuggestions: false,
          userInput: filteredSuggestions[activeSuggestion]
        });
        break;
      case UP_ARROW:
        e.preventDefault();
        this.listUp()
        break;
      case DOWN_ARROW:
        e.preventDefault();
        this.listDown()
        break;
    }
  };

  listUp(){
    const { activeSuggestion, filteredSuggestions } = this.state;
    if (activeSuggestion === 0) {
      return;
    }

    this.setState({ activeSuggestion: activeSuggestion - 1 });
  }

  listDown(){
    const { activeSuggestion, filteredSuggestions } = this.state;

    if (activeSuggestion == filteredSuggestions.length - 1) {
      return;
    }

    this.setState({ activeSuggestion: activeSuggestion + 1 });
  }

  render() {
    const {
      onChange,
      onClick,
      onKeyDown,
      state: {
        activeSuggestion,
        filteredSuggestions,
        showSuggestions,
        userInput
      }
    } = this;

    let suggestionsListComponent;

    if (showSuggestions && userInput) {
      if (filteredSuggestions.length) {
        suggestionsListComponent = (
          <ul className={style.suggestions}>
            {filteredSuggestions.map((suggestion, index) => {

              return (
                <li
                  className={index === activeSuggestion ? style.suggestion_active : ''}
                  key={suggestion.value}
                  onClick={onClick}
                >
                  {suggestion.label}
                </li>
              );
            })}
          </ul>
        );
      } else {
        suggestionsListComponent = (
          <div className={style.no_suggestions}>
            <em>No suggestions, you're on your own!</em>
          </div>
        );
      }
    }

    return (
      <Fragment>
        <input
          type="text"
          onChange={onChange}
          onKeyDown={onKeyDown}
          value={userInput.label}
        />
        {suggestionsListComponent}
      </Fragment>
    );
  }
}

export default Autocomplete;