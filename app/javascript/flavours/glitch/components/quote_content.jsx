import PropTypes from "prop-types";
import {useCallback} from "react";

import {defineMessages, injectIntl} from "react-intl";

import ImmutablePropTypes from "react-immutable-proptypes";

import QuoteIcon from "@/material-icons/400-24px/format_quote-fill.svg?react";
import {Avatar} from "flavours/glitch/components/avatar";
import {Icon} from "flavours/glitch/components/icon";
import {RelativeTimestamp} from "flavours/glitch/components/relative_timestamp";

const messages = defineMessages({
  edited: {id: 'status.edited', defaultMessage: 'Edited {date}'},
});

const QuoteContent = ({
  quoteStatus,
  parseClick,
  intl
}) => {
  let quoteStatusContent = {__html: quoteStatus.get('contentHtml')};
  let quoteStatusAccount = quoteStatus.get('account');
  let quoteStatusDisplayName = {__html: quoteStatusAccount.get('display_name_html')};
  const handle = quoteStatus.getIn(['account', 'acct']);
  const accountURL = quoteStatus.getIn(['account', 'url']);
  const statusID = quoteStatus.get('id');
  const createdAt = quoteStatus.get('created_at');
  const editedAt = quoteStatus.get('edited_at');

  const handleAccountClick = useCallback((e) => {
    parseClick(e, `/@${handle}`);
  }, [handle, parseClick]);

  const handleStatusClick = useCallback((e) => {
    parseClick(e, `/@${handle}/${statusID}`);
  }, [handle, statusID, parseClick]);

  return (
    <div className={"status__quote"} onClick={handleStatusClick}>
      <blockquote>
        <div className={"quote__header"}>
          <a href={accountURL} onClick={handleAccountClick}
            className={"quote__author"}
            data-hover-card-account={quoteStatus.getIn(['account', 'id'])}>
            <Icon
              fixedWidth
              aria-hidden='true'
              key='icon-quote-right'
              icon={QuoteIcon} />
            <Avatar account={quoteStatusAccount} size={24} />
            <bdi>
              <span className='quote__display-name'>
                <strong className={"display-name__html"}
                  dangerouslySetInnerHTML={quoteStatusDisplayName} />
              </span>
            </bdi>
            <span
              className={"quote__account deemphasized"}>
              @{handle}
            </span>

          </a>
          <span className={"quote__spacer deemphasized"}>
              ·
          </span>
          <a href={quoteStatus.get('url')}
            onClick={handleStatusClick}
            className={"quote__datetime deemphasized"}>
            <RelativeTimestamp timestamp={createdAt} />{editedAt && <abbr
              title={intl.formatMessage(messages.edited, {
                date: intl.formatDate(editedAt, {
                  year: 'numeric',
                  month: 'short',
                  day: '2-digit',
                  hour: '2-digit',
                  minute: '2-digit'
                })
              })}> *</abbr>}

          </a>
        </div>
        <div>
          <a className={"quote__content-link"}
            href={quoteStatus.get('url')}
            onClick={handleStatusClick}
            target='_blank' rel='noopener noreferrer'
          >
            <p className={"quote__content"} dangerouslySetInnerHTML={quoteStatusContent} />
          </a>

        </div>
      </blockquote>
    </div>
  );
};

QuoteContent.propTypes = {
  quoteStatus: ImmutablePropTypes.map.isRequired,
  parseClick: PropTypes.func.isRequired,
  intl: PropTypes.object.isRequired,
};

export default injectIntl(QuoteContent);
