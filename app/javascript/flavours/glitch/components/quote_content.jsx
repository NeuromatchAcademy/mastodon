import PropTypes from "prop-types";

import ImmutablePropTypes from "react-immutable-proptypes";

import QuoteIcon from "@/material-icons/400-24px/format_quote-fill.svg?react";
import {Icon} from "flavours/glitch/components/icon";


const QuoteContent = ({
  quoteStatus,
  handleAccountClick
}) => {
  let quoteStatusContent = { __html: quoteStatus.get('contentHtml') };
  let quoteStatusAccount = quoteStatus.get('account');
  let quoteStatusDisplayName = { __html: quoteStatusAccount.get('display_name_html') };

  return (
    <div className={"status__quote"}>
      <blockquote>
        <bdi>
          <span className='quote-display-name'>
            <Icon
              fixedWidth
              aria-hidden='true'
              key='icon-quote-right'
              icon={QuoteIcon} />
            <strong className={"display-name__html"}>
              <a onClick={handleAccountClick} href={quoteStatus.getIn(['account', 'url'])}
                dangerouslySetInnerHTML={quoteStatusDisplayName} />
            </strong>
          </span>
        </bdi>
        <div>
          <a href={quoteStatus.get('url')} target='_blank' rel='noopener noreferrer'
            dangerouslySetInnerHTML={quoteStatusContent} />
        </div>
      </blockquote>
    </div>
  );
};

QuoteContent.propTypes = {
  quoteStatus: ImmutablePropTypes.map.isRequired,
  handleAccountClick: PropTypes.func.isRequired,
};

export default QuoteContent;
