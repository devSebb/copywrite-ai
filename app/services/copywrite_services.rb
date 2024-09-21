class CopywriteService
  MAX_TOKENS = 4000  # Adjust based on your OpenAI plan and needs

  def initialize(text)
    @text = text
  end

  def improve_text
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [ { role: "user", content: improvement_prompt } ],
        max_tokens: [ MAX_TOKENS, @text.length * 1.5 ].min.to_i,
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")&.strip
  rescue StandardError => e
    Rails.logger.error("Error improving text: #{e.message}")
    "Sorry, an error occurred while improving the text: #{e.message}"
  end

  private

  def improvement_prompt
    <<~PROMPT
      Please improve the following text. Focus on:
      1. Enhancing clarity and readability
      2. Correcting any grammatical or spelling errors
      3. Improving the overall structure and flow
      4. Maintaining the original meaning and intent

      Text to improve:
      #{@text}
    PROMPT
  end
end
