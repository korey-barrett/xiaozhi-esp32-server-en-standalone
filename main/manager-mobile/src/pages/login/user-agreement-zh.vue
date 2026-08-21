<route lang="jsonc" type="page">
{
  "layout": "default",
  "style": {
    "navigationStyle": "custom",
    "navigationBarTitleText": "User Agreement"
  }
}
</route>

<script lang="ts" setup>
import { t } from '@/i18n'

function goBack() {
  uni.navigateBack()
}
</script>

<template>
  <view class="h-screen flex flex-col bg-[#f5f8fd]">
    <wd-navbar
      :title="t('login.userAgreement')"
      safe-area-inset-top
      left-arrow
      :bordered="false"
      @click-left="goBack"
    >
      <template #left>
        <wd-icon name="arrow-left" size="18" />
      </template>
    </wd-navbar>
    <scroll-view scroll-y class="box-border flex-1 px-[30rpx] py-[30rpx]">
      <view class="rounded-[16rpx] bg-white px-[30rpx] py-[40rpx] shadow-[0_4rpx_20rpx_rgba(0,0,0,0.05)]">
        <view class="mb-[40rpx] text-center">
          <text class="text-[36rpx] text-[#1a1a1a] font-bold">
            {{ t('login.userAgreement') }}
          </text>
        </view>
        <view class="mb-[40rpx] text-center">
          <text class="text-[24rpx] text-[#666666]">
            Last Updated: March 10, 2026
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            Important Notice
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Welcome to the Xiaozhi Backend Service (hereinafter referred to as "this Service"). This Service is designed to provide backend support to Xiaozhi AI hardware devices, including but not limited to intelligent voice interaction, visual understanding, intent recognition, conversation memory, knowledge-base Q&A, device management, and agent management. This Service is operated by the party that actually deploys and administers it (hereinafter referred to as the "Operator" or "we").
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Before you register, log in, or otherwise use this Service, please read and fully understand the terms of this Agreement carefully, especially those clauses presented in bold that draw your attention to matters of significant importance to your interests, including but not limited to disclaimers and limitations of liability.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            When you complete registration, log in, or otherwise use this Service in accordance with the on-screen instructions, you are deemed to have fully read, understood, and accepted all the terms of this Agreement. If you do not agree to this Agreement or any of its terms, please stop using this Service immediately.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            This Agreement may be updated and revised from time to time as circumstances require. Any revised Agreement shall be announced through notices on this platform. The revised Agreement shall take effect on the date of such announcement. If you continue to use this Service after the revision, you will be deemed to have accepted the revised Agreement.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            I. Definitions
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Xiaozhi Backend Service: refers to the Xiaozhi backend service and its deployed and running backend service system, including but not limited to the Control Console (administration backend), API interfaces, and WebSocket communication services.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Control Console: refers to the web administration interface provided by this Service, used for device management, agent configuration, user management, and other functions.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            User: refers to any natural person, legal person, or other organization that uses this Service through registration or by other means, hereinafter referred to as "you".
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Agent: refers to an AI persona created and configured within this Service, comprising a collection of capabilities such as language models, speech recognition, speech synthesis, visual understanding, intent recognition, conversation memory, and knowledge bases.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Device: refers to hardware devices such as ESP32 that are connected to and managed through this Service.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            II. Scope of the Agreement
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            This Agreement is the legal agreement between you and the Operator governing your use of this Service. This Agreement applies to all of your activities in using this Service through the Control Console or by any other means.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            The source code of this Service is governed by the applicable open-source license. This Agreement governs your use of this Service and does not affect the rights granted to you under the open-source license.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            III. Account Registration and Use
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.1 User Eligibility: You confirm that, before using this Service, you shall possess the civil capacity commensurate with your actions as required by the laws of the People's Republic of China. If you are a minor, you shall use this Service under the supervision and guidance of your legal guardian.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.2 Account Registration: You may register and log in to this Service using a mobile phone number and verification code, or a username and password. You shall provide true, accurate, and complete registration information and update it in a timely manner.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.3 Account Security: You shall properly safeguard your account and password. You shall bear all consequences arising from the disclosure or unauthorized use of your account due to your own actions. If you discover any security risk to your account, please contact the Operator immediately.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.4 Account Use Restrictions: Your account is for your personal use only. Without the Operator's consent, you may not transfer, rent, or lend your account to any third party in any manner.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.5 Account Cancellation: If you need to cancel your account, you may do so through the account settings function in the Control Console, or by contacting the Operator. After account cancellation, relevant data will be deleted and cannot be recovered, so please proceed with caution.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            IV. Services
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.1 Overview of Services: This Service leverages artificial intelligence technologies and invokes third-party generative AI models through API interfaces to provide intelligent interaction services to connected hardware devices, including but not limited to voice activity detection (VAD), speech recognition (ASR), semantic understanding (LLM), speech synthesis (TTS), visual understanding (VLLM), intent recognition (Intent), conversation memory (Memory), and knowledge bases (RAG).
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.2 Agent Management: You may create and configure agents through the Control Console, including setting character templates, selecting language models, configuring voice parameters, setting intent recognition rules, managing knowledge bases, enabling conversation memory, and configuring agent plugins. The content you configure for an agent must not violate national laws and regulations.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.3 Device Management: You may bind and manage your hardware devices through the Control Console, and perform operations such as device configuration, firmware updates, and OTA remote upgrades. You shall ensure that the devices you manage are lawfully owned by you or that you have been duly authorized to manage them.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.4 Visual Understanding: This Service supports capturing images through the device camera and invoking third-party vision models for image recognition and scene understanding. You shall ensure that your image-capture activities comply with applicable laws and regulations and do not infringe upon others' privacy.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.5 Intent Recognition: This Service may use intent recognition to understand the intent of your instructions and trigger corresponding actions or services accordingly, such as controlling smart devices or querying information.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.6 Conversation Memory: This Service may record and store summaries of your interaction history with agents in order to provide a more coherent and personalized interaction experience in subsequent conversations. You may manage or clear your memory data in the Control Console.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.7 Knowledge Base: This Service allows you to upload documents, text, and other content to build a knowledge base, from which agents may retrieve content during conversations to provide you with Q&A services. You shall ensure that the content uploaded to the knowledge base does not infringe upon the intellectual property rights of third parties and does not contain content that violates laws and regulations.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.8 Voiceprint Recognition: This Service supports voiceprint recognition. You may register voiceprint samples to enable speaker identity verification and personalized services. Voiceprint data will be used for identity verification purposes.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.9 Voice Cloning: This Service supports voice cloning. You may clone a custom voice by providing audio samples. Cloned voices are for your personal use only and may not be used to impersonate others or to engage in unlawful or improper activities.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.10 MCP Endpoints: This Service supports the MCP (Model Context Protocol). It may act as an MCP Server to provide tool-calling capabilities to external parties, and may also act as an MCP Client to invoke external MCP services, enabling standardized integration with external systems.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.11 Context Providers: This Service supports the Context Provider feature, which can retrieve real-time information from external data sources, such as weather, news, and stocks, providing agents with a richer source of knowledge.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.12 MQTT Protocol: This Service supports the MQTT (Message Queuing Telemetry Transport) protocol for message communication with IoT devices. Through the MQTT protocol, you may implement functions such as sending device control commands and monitoring device status.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.13 Disclaimer on Output: The conversations and responses generated by the third-party AI models on which this Service relies are for reference only and do not constitute professional advice of any kind. You shall not rely on the output as professional advice in fields such as medicine, law, or finance. You bear full responsibility for any judgment or decision you make based on the output.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.14 Service Fees: This Service is a free open-source project and does not charge users any usage fees. It merely provides the platform capability to invoke third-party services and does not involve any paid features or value-added services.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            This Service supports multiple AI service providers. The billing models of different providers are as follows:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[60rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) Free services: Some providers offer free quotas or fully free services, such as Zhipu AI (free models including glm-4-flash) and Microsoft EdgeTTS speech synthesis.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[60rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) Pay-per-use services: Some providers bill based on API usage, such as OpenAI, Alibaba Cloud Intelligent Speech, Baidu ERNIE, and iFlytek. You are responsible for paying the corresponding fees directly to the third-party providers; such fees are unrelated to this Service.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[60rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (3) Local deployment solutions: This Service supports fully local deployment of AI solutions, such as FunASR for speech recognition, FishSpeech for speech synthesis, and Ollama for local large language models. Local deployment incurs no network or API call fees, but requires sufficient local computing resources.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.15 Changes to Services: The Operator reserves the right to adjust, upgrade, or discontinue the services as circumstances require, and will endeavor to provide prior notice wherever possible.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            V. Code of Conduct for Users
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.1 Lawful Use: When using this Service, you shall comply with the laws and regulations of the People's Republic of China and relevant international treaties, and shall not use this Service to engage in any unlawful or improper activities.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.2 Prohibited Conduct: You undertake that, when using this Service, you shall not engage in any of the following conduct:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) Publishing, transmitting, or storing content that endangers national security or social stability, including but not limited to content involving subversion of state power, damage to national honor or interests, or incitement of ethnic hatred.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) Publishing, transmitting, or storing content that infringes upon the lawful rights and interests of others, including but not limited to infringements of intellectual property rights, privacy rights, and reputation rights.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (3) Publishing, transmitting, or storing obscene, pornographic, violent, terrorist, or crime-inciting content.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (4) Publishing false information, spreading rumors, or engaging in fraudulent conduct.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (5) Interfering with the normal operation of this Service in any manner, including but not limited to attacking servers, spreading malicious programs, or maliciously consuming system resources.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (6) Reverse-engineering, decompiling, or otherwise attempting to obtain the system source code of this Service without authorization (this clause does not restrict your lawful use of the open-source code under the open-source license).
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (7) Using this Service for automated batch operations that maliciously consume API call quotas or other system resources.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (8) Entering content into agent configurations that violates laws and regulations or public order and good morals.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (9) Using this Service to harm or attempt to harm minors.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (10) Any other conduct that violates laws and regulations, the terms of this Agreement, or that may harm the lawful rights and interests of the Operator or third parties.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.3 Handling of Violations: If you violate the above code of conduct, the Operator has the right to take measures such as warnings, restricting functions, suspending services, or banning accounts depending on the severity of the circumstances, and reserves the right to pursue legal liability.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            VI. Intellectual Property
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.1 Open-Source License: This Service is an open-source project, and its source code is governed by the applicable open-source license. You may use the relevant source code in compliance with the terms of that license.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.2 Ownership of Service Content: Except for the open-source code, the intellectual property rights in the interface design, icons, text, and other content independently created by the Operator within this Service belong to the Operator.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.3 User Content: The intellectual property rights in the content you input, upload, or generate through this Service shall be determined in accordance with applicable laws and regulations. You grant the Operator the right to store and perform the necessary processing of your input content for the purposes of maintaining and improving the Service.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.4 Third-Party Rights: When using this Service, you shall respect the intellectual property and other lawful rights and interests of third parties. You bear full responsibility for any disputes arising from your infringement of third-party rights.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            VII. Privacy Protection
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            7.1 Information Collection: To provide this Service, the Operator may collect your registration information (such as mobile phone number and username), device information, and usage logs. Please refer to the Privacy Policy for the specific rules on the collection and use of personal information.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            7.2 Information Protection: The Operator will adopt reasonable technical and administrative measures to protect the security of your personal information. However, due to the open nature of the Internet, the Operator cannot absolutely guarantee information security. Please take care to protect your sensitive personal information.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            7.3 Information Security Notice: Please do not disclose sensitive personal information such as your financial account, bank card, or passwords to the AI during your use of this Service. Any losses arising therefrom shall be borne by you.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            VIII. Disclaimer
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.1 AI-Generated Content: This Service relies on third-party AI models to provide intelligent interaction capabilities. AI-generated content may be inaccurate, incomplete, or inappropriate. The Operator makes no warranty whatsoever as to the truthfulness, accuracy, or completeness of AI-generated content.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.2 Service Interruption: The Operator shall not be liable for service interruptions or abnormalities arising from the following causes:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) Force majeure events, such as natural disasters, epidemics, or war.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) Public service factors such as power supply failures or communication network failures.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (3) Service failures or policy changes by third-party AI model providers.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (4) Temporary service interruptions caused by system maintenance or upgrades.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (5) Network security incidents such as hacking attacks or computer viruses.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (6) Service adjustments resulting from laws, regulations, or government regulation.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (7) Other circumstances not attributable to the fault of the Operator.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.3 Third-Party Services: This Service may involve services provided by third parties, including language models, speech recognition, speech synthesis, vision models, and intent recognition. When using them, you shall also comply with the terms of service of the relevant third parties. For any issues arising from third-party services, please contact the third party directly.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.4 Open-Source Disclaimer: This Service is an open-source project provided "as is." To the maximum extent permitted by law, the Operator makes no express or implied warranties regarding the merchantability, fitness for a particular purpose, or non-infringement of this Service.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.5 Special Statement on Open-Source Software: This project is open-source software. There is no commercial partnership between this Service and any third-party API providers it integrates with (including but not limited to speech recognition, large language model, and speech synthesis platforms), and this Service provides no warranty whatsoever with respect to their service quality or the security of your funds. This software does not hold any account keys, does not participate in any fund transfers, and does not assume any risk of loss of recharged funds.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.6 Security Warning: This project's features are not fully developed and it has not passed network security assessment. Please do not use it in a production environment. If you deploy this project on a public network for learning purposes, be sure to take the necessary protective measures, including but not limited to setting strong passwords, restricting access permissions, and enabling HTTPS encrypted transmission.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            IX. Protection of Minors
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            9.1 If you are a minor under 18 years of age, you shall use this Service under the guidance and with the consent of your guardian.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            9.2 Guardians shall strengthen their supervision over minors' use of this Service and guide minors to use it reasonably, avoiding excessive reliance on it.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            9.3 Minors shall pay attention to the protection of their personal information when using this Service and avoid uploading or disclosing sensitive personal information.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            X. Termination of the Agreement
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.1 Termination by User: You have the right to stop using this Service and cancel your account at any time.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.2 Termination by Operator: The Operator has the right to terminate the provision of services to you under the following circumstances:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) You breach the terms of this Agreement.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) You use this Service to engage in unlawful or improper activities.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (3) As required by laws, regulations, or policies.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (4) The Operator decides to cease operating this Service.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.3 Post-Termination Handling: After termination of the Agreement, the Operator has no obligation to retain your account information or related data. The Operator retains the right to pursue your liability for breach of contract committed during the term of the Agreement.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            XI. Governing Law and Dispute Resolution
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            11.1 The formation, effectiveness, interpretation, revision, and termination of this Agreement, as well as the resolution of disputes arising hereunder, shall all be governed by the laws of the People's Republic of China.
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            11.2 Any dispute arising from this Agreement or this Service shall first be resolved through friendly negotiation between the parties. If negotiation fails, either party has the right to file a lawsuit with a competent people's court located at the Operator's place of business.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            11.3 If any term of this Agreement is held to be invalid or unenforceable, the validity of the remaining terms shall be unaffected.
          </text>
        </view>

        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] font-semibold">
            XII. Miscellaneous
          </text>
        </view>
        <view class="mb-[24rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            12.1 This Agreement constitutes the entire agreement between you and the Operator regarding your use of this Service.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            12.2 The Operator's failure to exercise, or delay in exercising, any right under this Agreement shall not constitute a waiver of such right.
          </text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<style lang="scss" scoped>
</style>
