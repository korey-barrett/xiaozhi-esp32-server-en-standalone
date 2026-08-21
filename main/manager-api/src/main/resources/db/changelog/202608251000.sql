-- Add English Edge TTS voices (US / UK / Australia) so agents can use English speech.
INSERT IGNORE INTO `ai_tts_voice` (`id`, `tts_model_id`, `name`, `tts_voice`, `languages`, `voice_demo`, `remark`, `sort`) VALUES
('TTS_EdgeTTS0012', 'TTS_EdgeTTS', 'Aria (Female, English US)', 'en-US-AriaNeural', 'English', NULL, 'en-US', 12),
('TTS_EdgeTTS0013', 'TTS_EdgeTTS', 'Jenny (Female, English US)', 'en-US-JennyNeural', 'English', NULL, 'en-US', 13),
('TTS_EdgeTTS0014', 'TTS_EdgeTTS', 'Guy (Male, English US)', 'en-US-GuyNeural', 'English', NULL, 'en-US', 14),
('TTS_EdgeTTS0015', 'TTS_EdgeTTS', 'Christopher (Male, English US)', 'en-US-ChristopherNeural', 'English', NULL, 'en-US', 15),
('TTS_EdgeTTS0016', 'TTS_EdgeTTS', 'Michelle (Female, English US)', 'en-US-MichelleNeural', 'English', NULL, 'en-US', 16),
('TTS_EdgeTTS0017', 'TTS_EdgeTTS', 'Emma (Female, English US)', 'en-US-EmmaNeural', 'English', NULL, 'en-US', 17),
('TTS_EdgeTTS0018', 'TTS_EdgeTTS', 'Sonia (Female, English UK)', 'en-GB-SoniaNeural', 'English', NULL, 'en-GB', 18),
('TTS_EdgeTTS0019', 'TTS_EdgeTTS', 'Ryan (Male, English UK)', 'en-GB-RyanNeural', 'English', NULL, 'en-GB', 19),
('TTS_EdgeTTS0020', 'TTS_EdgeTTS', 'Libby (Female, English UK)', 'en-GB-LibbyNeural', 'English', NULL, 'en-GB', 20),
('TTS_EdgeTTS0021', 'TTS_EdgeTTS', 'Natasha (Female, English AU)', 'en-AU-NatashaNeural', 'English', NULL, 'en-AU', 21),
('TTS_EdgeTTS0022', 'TTS_EdgeTTS', 'William (Male, English AU)', 'en-AU-WilliamNeural', 'English', NULL, 'en-AU', 22),
('TTS_EdgeTTS0023', 'TTS_EdgeTTS', 'Annette (Female, English AU)', 'en-AU-AnnetteNeural', 'English', NULL, 'en-AU', 23);
