"use strict";

export enum ChatState {
    LoadingHistory,
    Init,
    Chating
}

export interface ChatMessage {
  id: string;
  text: string;
  type: string;
  order: number;
}