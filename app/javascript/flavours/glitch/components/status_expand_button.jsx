import PropTypes from 'prop-types';
import React, { useState, useEffect } from 'react';

import { FormattedMessage } from 'react-intl';

import ImageIcon from '@/material-icons/400-24px/image.svg?react';
import InsertChartIcon from '@/material-icons/400-24px/insert_chart.svg?react';
import LinkIcon from '@/material-icons/400-24px/link.svg?react';
import MovieIcon from '@/material-icons/400-24px/movie.svg?react';
import MusicNoteIcon from '@/material-icons/400-24px/music_note.svg?react';
import { Icon } from 'flavours/glitch/components/icon';

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
      const mediaComponents = {
        'link': LinkIcon,
        'picture-o': ImageIcon,
        'tasks': InsertChartIcon,
        'video-camera': MovieIcon,
        'music': MusicNoteIcon,
      };

      mediaIcons.forEach((mediaIcon, idx) => {
        newText.push(
          <Icon
            fixedWidth
            className='status__content__spoiler-icon'
            id={mediaIcon}
            icon={mediaComponents[mediaIcon]}
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
)=>{

  const [toggleText, setToggleText] = useState(makeToggleText());

  // Change the text when the hidden state changes
  useEffect(() => {
    setToggleText(makeToggleText(hidden, mediaIcons));
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
