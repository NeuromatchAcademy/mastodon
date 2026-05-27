import { createAction } from '@reduxjs/toolkit';

import {
  apiGetContext,
  apiSetQuotePolicy,
  apiSticky,
  apiUnsticky,
} from 'flavours/glitch/api/statuses';
import { createDataLoadingThunk } from 'flavours/glitch/store/typed_functions';

import type { ApiQuotePolicy } from '../api_types/quotes';

import { importFetchedStatus, importFetchedStatuses } from './importer';

export const fetchContext = createDataLoadingThunk(
  'status/context',
  ({ statusId }: { statusId: string; prefetchOnly?: boolean }) =>
    apiGetContext(statusId),
  ({ context, refresh }, { dispatch, actionArg: { prefetchOnly = false } }) => {
    const statuses = context.ancestors.concat(context.descendants);

    dispatch(importFetchedStatuses(statuses));

    return {
      context,
      refresh,
      prefetchOnly,
    };
  },
);

export const completeContextRefresh = createAction<{ statusId: string }>(
  'status/context/complete',
);

export const showPendingReplies = createAction<{ statusId: string }>(
  'status/context/showPendingReplies',
);

export const clearPendingReplies = createAction<{ statusId: string }>(
  'status/context/clearPendingReplies',
);

export const setStatusQuotePolicy = createDataLoadingThunk(
  'status/setQuotePolicy',
  ({ statusId, policy }: { statusId: string; policy: ApiQuotePolicy }) => {
    return apiSetQuotePolicy(statusId, policy);
  },
);

export const sticky = createDataLoadingThunk(
  'status/sticky',
  ({ statusId }: { statusId: string }) => apiSticky(statusId),
  (status, { dispatch }) => {
    dispatch(importFetchedStatus(status));
  },
);
export const unsticky = createDataLoadingThunk(
  'status/unsticky',
  ({ statusId }: { statusId: string }) => apiUnsticky(statusId),
  (status, { dispatch }) => {
    dispatch(importFetchedStatus(status));
  },
);
