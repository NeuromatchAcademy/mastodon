import { createAction } from '@reduxjs/toolkit';

import type { ApiStatusJSON } from 'flavours/glitch/api_types/statuses';

export const threadMount = createAction('THREAD_MOUNT');
export const threadUnmount = createAction('THREAD_UNMOUNT');

interface ThreadUpdatePayload {
  status: ApiStatusJSON;
}

export const threadUpdate = createAction<ThreadUpdatePayload>('THREAD_UPDATE');
