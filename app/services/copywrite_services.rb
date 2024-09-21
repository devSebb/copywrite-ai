class CopywriteServices
  MAX_MODEL_TOKENS = 8192
  MAX_COMPLETION_TOKENS = 2048

  def initialize(text)
    @text = text
  end

  def improve_text
    client = OpenAI::Client.new

    prompt = improvement_prompt(@text)
    prompt_tokens = count_tokens(prompt)
    max_tokens = [ MAX_MODEL_TOKENS - prompt_tokens, MAX_COMPLETION_TOKENS ].min

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [ { role: "user", content: prompt } ],
        max_tokens: max_tokens,
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")&.strip
  rescue StandardError => e
    Rails.logger.error("Error improving text: #{e.message}")
    "Sorry, an error occurred while improving the text: #{e.message}"
  end

  private

  def improvement_prompt(text)
    <<~PROMPT
      As an expert editor and writer, your task is to enhance the following text while preserving its original meaning and intent. Please:

      - Improve clarity and readability.
      - Correct grammatical, punctuation, and spelling errors.
      - Enhance sentence structure and flow.
      - Use appropriate vocabulary and tone for a general audience.
      - Remove any redundancy or unnecessary phrases.
      - Keep the content factual without adding personal opinions or extraneous information.

      Provide only the revised text without any additional comments or introductions.

      Text to improve:
      "#{text}"
    PROMPT
  end

  def count_tokens(text)
    (text.length / 4).to_i
  end
end
