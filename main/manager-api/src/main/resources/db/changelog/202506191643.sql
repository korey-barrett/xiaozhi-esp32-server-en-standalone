-- LLM intent recognition configuration instructions
UPDATE `ai_model_config` SET 
`doc_link` = NULL,
`remark` = 'LLM intent recognition configuration instructions:
1. Use a dedicated LLM for intent recognition
2. By default uses the selected_module.LLM model
3. Can be configured to use a dedicated LLM (such as the free ChatGLMLLM)
4. Highly versatile, but increases processing time
Configuration instructions:
1. Specify the LLM model to use in the llm field
2. If not specified, the selected_module.LLM model is used' WHERE `id` = 'Intent_intent_llm';

-- Function-call intent recognition configuration instructions
UPDATE `ai_model_config` SET 
`doc_link` = NULL,
`remark` = 'Function-call intent recognition configuration instructions:
1. Use the function_call capability of the LLM for intent recognition
2. The selected LLM must support function_call
3. Calls tools on demand and processes quickly' WHERE `id` = 'Intent_function_call';