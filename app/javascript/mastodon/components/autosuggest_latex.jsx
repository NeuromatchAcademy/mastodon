import PropTypes from 'prop-types';
import React from 'react';

export default class AutosuggestLatex extends React.PureComponent {

  static propTypes = {
    latex: PropTypes.object.isRequired,
  };

  setRef = (c) => {
    this.node = c;
  };

  componentDidMount() {
    try {
      // Loaded in script tag on page. not great but we couldn't figure out
      // How to use MathJax as a module
      // eslint-disable-next-line no-undef
      MathJax.typeset([this.node]);
    } catch(e) {
      console.error(e);
    }

  }

  render () {
    const { latex } = this.props;

    return (
      <div className='autosuggest-latex' ref={this.setRef}>
        \({latex.expression}\)
        <br />
        <small>Convert to unicode</small>
      </div>
    );
  }

}
