import PropTypes from 'prop-types';
import React, { useState, useEffect } from 'react';

import { FormattedMessage } from 'react-intl';

import { Icon } from './icon';

const makeToggleText = (hidden, mediaIcons) => {
  let newText;
  if (hidden) {
    newText = [
      <FormattedMessage
        id='status.show_more'
        defaultMessage='Show more'
        key='0'
      />,
    ];
    if (mediaIcons) {
      mediaIcons.forEach((mediaIcon, idx) => {
        newText.push(
          <Icon
            fixedWidth
            className='status__content__spoiler-icon'
            id={mediaIcon}
            aria-hidden='true'
            key={`icon-${idx}`}
          />,
        );
      });
    }
  } else {
    newText = (
      <FormattedMessage
        id='status.show_less'
        defaultMessage='Show less'
        key='0'
      />
    );
  }
  return(newText);
};

const StatusExpandButton=(
  {
    hidden,
    handleSpoilerClick,
    mediaIcons,
  },
) => {
  const [toggleText, setToggleText] = useState(makeToggleText(hidden, mediaIcons));

  // Change the text when the hidden state changes
  useEffect(() => {
    let text = makeToggleText(hidden, mediaIcons);
    setToggleText(text);
  }, [hidden, mediaIcons]);

  return(
    <button type='button' className='status__content__spoiler-link' onClick={handleSpoilerClick} aria-expanded={!hidden}>
      {toggleText}
    </button>
  );
};

StatusExpandButton.propTypes = {
  hidden: PropTypes.bool,
  handleSpoilerClick: PropTypes.func,
  mediaIcons: PropTypes.arrayOf(PropTypes.string),
};

export default StatusExpandButton;
