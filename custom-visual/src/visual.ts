"use strict";

import powerbi from "powerbi-visuals-api";
import { FormattingSettingsService } from "powerbi-visuals-utils-formattingmodel";
import "./../style/visual.less";

import VisualConstructorOptions = powerbi.extensibility.visual.VisualConstructorOptions;
import VisualUpdateOptions = powerbi.extensibility.visual.VisualUpdateOptions;
import IVisual = powerbi.extensibility.visual.IVisual;

import { VisualFormattingSettingsModel } from "./settings";
import { every, ribbon, text } from "d3";

import { ChatState, ChatMessage } from "./state";
import ILocalVisualStorageService = powerbi.extensibility.ILocalVisualStorageService;

export class Visual implements IVisual {

  private target: HTMLElement;

  private state: ChatState;
  private msgCount = 0;
  private messages: Map<string, ChatMessage> = new Map<string, ChatMessage>();

  private controller: AbortController;

  private errorTimeout;

  constructor(options: VisualConstructorOptions) {

    this.state = ChatState.LoadingHistory;
    this.controller = new AbortController();

    options.element.style.overflow = "auto";
    this.target = options.element;

    this.target.innerHTML = `
      <div class='main'>
        <div id='error-popup' class='error-popup'>
          Your question should not be empty
        </div>


        <div id='upper-content' class='upper-content'>

        </div>
        
        <div class='question-content'>
          <form id='my-form' class='my-form'>
          <div class='my-form__wrapper-input'>
            <div class='textbox-input'>
                <div class='textbox-input__icon'>
                    <svg  viewBox="0 -0.5 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M18.1 5.00016H6.9C6.53425 4.99455 6.18126 5.13448 5.9187 5.38917C5.65614 5.64385 5.50553 5.99242 5.5 6.35816V14.5002C5.50553 14.8659 5.65614 15.2145 5.9187 15.4692C6.18126 15.7238 6.53425 15.8638 6.9 15.8582H10.77C10.9881 15.857 11.2035 15.9056 11.4 16.0002L17.051 19.0002L17 14.5002H18.43C19.0106 14.5091 19.4891 14.0467 19.5 13.4662V6.35816C19.4945 5.99242 19.3439 5.64385 19.0813 5.38917C18.8187 5.13448 18.4657 4.99455 18.1 5.00016Z" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M8.5 8.25024C8.08579 8.25024 7.75 8.58603 7.75 9.00024C7.75 9.41446 8.08579 9.75024 8.5 9.75024V8.25024ZM16.5 9.75024C16.9142 9.75024 17.25 9.41446 17.25 9.00024C17.25 8.58603 16.9142 8.25024 16.5 8.25024V9.75024ZM8.5 11.2502C8.08579 11.2502 7.75 11.586 7.75 12.0002C7.75 12.4145 8.08579 12.7502 8.5 12.7502V11.2502ZM14.5 12.7502C14.9142 12.7502 15.25 12.4145 15.25 12.0002C15.25 11.586 14.9142 11.2502 14.5 11.2502V12.7502ZM8.5 9.75024H16.5V8.25024H8.5V9.75024ZM8.5 12.7502H14.5V11.2502H8.5V12.7502Z" fill="#000000"/>
                    </svg>
                </div>
                <input value='' class='textbox-input__input' id='question' type='text' placeholder='Your question...'/>
            </div>

            <div id='submit-text' class='submit-wrapper'>
              <div class='submit-icon'>
                <svg viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
          
                <title>Submit</title>
                <desc>Created with Sketch Beta.</desc>
                <defs>
          
                </defs>
                <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
                  <g id="Icon-Set" sketch:type="MSLayerGroup" transform="translate(-308.000000, -1087.000000)" fill="#000000">
                      <path
                          d="M324,1117 C316.268,1117 310,1110.73 310,1103 C310,1095.27 316.268,1089 324,1089 C331.732,1089 338,1095.27 338,1103 C338,1110.73 331.732,1117 324,1117 L324,1117 Z M324,1087 C315.163,1087 308,1094.16 308,1103 C308,1111.84 315.163,1119 324,1119 C332.837,1119 340,1111.84 340,1103 C340,1094.16 332.837,1087 324,1087 L324,1087 Z M330.535,1102.12 L324.879,1096.46 C324.488,1096.07 323.855,1096.07 323.465,1096.46 C323.074,1096.86 323.074,1097.49 323.465,1097.88 L327.586,1102 L317,1102 C316.447,1102 316,1102.45 316,1103 C316,1103.55 316.447,1104 317,1104 L327.586,1104 L323.465,1108.12 C323.074,1108.51 323.074,1109.15 323.465,1109.54 C323.855,1109.93 324.488,1109.93 324.879,1109.54 L330.535,1103.88 C330.775,1103.64 330.85,1103.31 330.795,1103 C330.85,1102.69 330.775,1102.36 330.535,1102.12 L330.535,1102.12 Z"
                          id="arrow-right-circle" sketch:type="MSShapeGroup">
          
                      </path>
                  </g>
                </g>
                </svg>
              </div>
            </div>

            <div id='cancel' class='cancel-wrapper'>
              <div class='cancel-icon'>
                <svg viewBox="0 0 512 512" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <title>Cancel</title>
                    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                    <g id="work-case" fill="#000000" transform="translate(91.520000, 91.520000)">
                    <polygon id="Close" points="328.96 30.2933333 298.666667 1.42108547e-14 164.48 134.4 30.2933333 1.42108547e-14 1.42108547e-14 30.2933333 134.4 164.48 1.42108547e-14 298.666667 30.2933333 328.96 164.48 194.56 298.666667 328.96 328.96 298.666667 194.56 164.48">
        
                        </polygon>
                        </g>
                    </g>
                </svg>
              </div>
            </div>
        </div>
    </form>
        </div>
      </div>
    `;

    this.init();

    document.getElementById("cancel")?.addEventListener("click", (event) => {
      this.cancel();
    });

    document
      .getElementById("submit-text")
      ?.addEventListener("click", (event) => {
        this.makeRequest(
          (<HTMLInputElement>document.getElementById("question")).value
        );
      });

  }

  private async init() {
    this.reload();
    try {
      let map = await fetch("https://tkus-im.arks.im/history", {
        method: "GET",
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Request-Headers": "*",
          "Access-Control-Request-Method": "*",
        },
        mode: "cors"
      })
      .then((response) => response.json());
      console.log(map);
      
      if (map) {
        let res = map['history']
        .replaceAll(String.fromCharCode(92), '');

        console.log(res);
        const parsed: Map<string, ChatMessage> = JSON.parse(
          res
        );
        console.log(parsed);

        this.state = ChatState.Chating;
        this.messages = parsed;
        this.msgCount = Object.keys(parsed).length;
        console.log("msgCount => " + this.msgCount);
      } 
    } catch (err) {
      console.log('error => ');
      console.log(err);
      this.state = ChatState.Init;
    } finally {
      this.reload();
    }
    
  }

  public update(options: VisualUpdateOptions) {}

  private reload() {
    switch (this.state) {
      case ChatState.Init: {
        document.getElementById("upper-content").innerHTML = `
        <div class='init-slide'>
          <p id='try-smth' class='try-smth' >Try something like this</p>

          <div id='option-btns' class='options'>
            <button id='btn-1' class='options__btn' type="button">What is the average amount of daily deposits collected in Lockbox 3?</button>
            <button id='btn-2' class='options__btn' type="button">What is the variance of Lockbox 3 and what are average variances of other payments?</button>
          </div>
        </div>
        `;

        document
          .getElementById("option-btns")
          ?.addEventListener("click", (event) => {
            this.makeRequest((<HTMLButtonElement>event.target).innerText);
          });
        break;
      }
      case ChatState.Chating: {
        this.reloadChat();
        break;
      }

      case ChatState.LoadingHistory: {
        this.addLoadingTitle();
        break;
      }
    }
  }

  private addLoadingTitle() {
    document.getElementById("upper-content").innerHTML = `
        <div class='loading-title'>
          Loading visual please wait...
        </div>
        `;
  }

  private reloadChat() {
    if (this.msgCount == 0) {
      document.getElementById("upper-content").innerHTML = `
    <div id='wrapper-chat' class='wrapper-chat'>
        <div id='chat-dialog' class='chat-dialog'>
     
        </div>
    </div>
    `;
    } else {
      let chatHtml = `
      <div id='wrapper-chat' class='wrapper-chat'>
          <div id='chat-dialog' class='chat-dialog'>`;

      let messagesArr = [];

      for (let el of Object.values(this.messages)) {
        if (el.text === "Loading please wait...") {
          el.text = "Sorry but I don't know the answer to this question";
        }

        messagesArr.push(el);
      }

      messagesArr = messagesArr.sort((a,b) => a.order - b.order)
      messagesArr.forEach((el) => {
        chatHtml += `
          <div id='${el.id}' class='message ${el.type}'>${el.text}</div>
        `;
      });

      chatHtml += `</div>
      </div>`;

      document.getElementById("upper-content").innerHTML = chatHtml;
    }
  }

  private makeRequest(text: string) {
    if (!text) {
      this.toErrorString();
      return;
    }

    if (this.state != ChatState.Chating) {
      this.state = ChatState.Chating;
      this.reload();
    }

    this.addMessage(text);

    const guid = this.uuidv4();
    setTimeout(
      () => {
        this.addAiLoadingMsg(guid);
      },
      300,
      true
    );

    fetch("https://tkus-im.arks.im/", {
      signal: this.controller.signal,
      method: "POST",
      body: JSON.stringify({
        model: "llama2:7b-chat-q4_0",
        prompt: text,
        stream: false,
      }),
      headers: {
        "Content-type": "application/json; charset=UTF-8",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Request-Headers": "*",
        "Access-Control-Request-Method": "*",
      },
      mode: "cors",
    })
      .then((response) => response.text())
      .then((json) => {
        this.addAiLoadedMsg(json, guid, false);
      })
      .catch((error) => {
        this.addAiLoadedMsg(
          "Sorry but I don't know the answer to this question",
          guid,
          false
        );
      });
  }

  private addMessage(text: string) {
    if (this.state == ChatState.Chating) {
      let chat = document.getElementById("chat-dialog");
      if (chat) {
        let el = document.createElement("div");
        el.classList.add("message");
        el.classList.add("user");
        el.id = this.uuidv4();
        el.innerHTML = `${text}`;

        chat.appendChild(el);
        (<HTMLInputElement>document.getElementById("question")).value = "";

        this.updateScroll();

        this.addToMessages(el.id, text, "user");
      }
    }
  }

  private addAiLoadingMsg(id: string) {
    if (this.state == ChatState.Chating) {
      let chat = document.getElementById("chat-dialog");

      let ifExists = document.getElementById(id);
      if (chat && !ifExists) {
        let el = document.createElement("div");
        el.classList.add("message");
        el.classList.add("ai");
        el.id = id;
        el.innerHTML = `Loading please wait...`;
        chat.appendChild(el);

        this.updateScroll();
        this.addToMessages(el.id, "Loading please wait...", "ai");
      }
    }
  }

  private addAiLoadedMsg(text: string, id: string, toScroll: boolean) {
    let result = text
      .replaceAll(/\\n/g, "<br/>")
      .replaceAll('"', "")
      .replace("<br/>", "");

    if (this.state == ChatState.Chating) {
      setTimeout(
        () => {
          let msg = document.getElementById(id);
          if (msg) {
            msg.innerHTML = result;

            this.addToMessages(id, result, "ai");

            if (toScroll) this.updateScroll();
          }
        },
        400,
        true
      );
    }
  }

  private toErrorString() {
    document.getElementById("error-popup").classList.add("error-popup-visible");

    clearTimeout(this.errorTimeout);
    this.errorTimeout = setTimeout(() => {
      document
        .getElementById("error-popup")
        .classList.remove("error-popup-visible");
    }, 1000);
  }

  private updateScroll() {
    document.getElementById("wrapper-chat").scrollTop = 0;
  }

  private cancel() {
    this.state = ChatState.Init;
    (<HTMLInputElement>document.getElementById("question")).value = "";
    this.reload();
    this.controller.abort();
    this.controller = new AbortController();

    fetch("https://tkus-im.arks.im/history", {
        method: "DELETE",
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Request-Headers": "*",
          "Access-Control-Request-Method": "*",
        },
        mode: "cors"
      })

    this.messages = new Map();
    this.msgCount = 0;
  }

  private uuidv4(): string {
    return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, (c) =>
      (
        +c ^
        (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (+c / 4)))
      ).toString(16)
    );
  }

  private async addToMessages(id: string, msgToSave: string, type: string) {
    console.log(msgToSave)
    let msg = msgToSave.replaceAll('"','').replaceAll("\"",'').replaceAll("'",'')
    console.log(msg)

    if (!this.messages[id]) {
      const chatMessage: ChatMessage = {
        id: id,
        text: msg,
        type: type,
        order: this.msgCount++,
      };
      this.messages[id] = chatMessage;
    } else {
      this.messages[id].text = msg;
    }

    try {
      console.log('save to storage');
      await fetch("https://tkus-im.arks.im/history", {
        method: "POST",
        headers: {
          "Content-type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Request-Headers": "*",
          "Access-Control-Request-Method": "*",
        },
        mode: "cors",
        body: JSON.stringify({
          history: this.messages,
        }) 
      })
    } catch(err) {
      console.log('error => ');
      console.log(err);
    }
  }
}
