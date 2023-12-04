class Password
  include ActiveModel::Model

  attr_accessor :password

  validates_length_of :password, minimum: 12, too_short: "please enter at least twelve characters"

  validate :contains_digit
  validate :contains_lower_case_letter
  validate :contains_symbol
  validate :contains_upper_case_letter
  validate :passes_zxcvbn_checks

  private

  def passes_zxcvbn_checks
    results = Zxcvbn.zxcvbn(password)
    # "score"=>1,
    # "feedback"=>{"warning"=>"This is similar to a commonly used password", "suggestions"=>["Add another word or two. Uncommon words are better."]}}
    score = results["score"]
    error_text = results.dig("feedback", "warning")
    suggestion = results.dig("feedback", "suggestions").join(". ")

    if score < 3
      message = if error_text.present?
          [error_text, suggestion].join(". ")
        else
          suggestion
        end

      return errors.add(:password, message)
    end

    if score < 4
      return errors.add(:password, "Your password needs more entropy. Try adding another word")
    end
  end

  def contains_lower_case_letter
    pattern = /[a-z]/
    errors.add(:password, "Must contain a lower case letter") unless pattern.match?(password)
  end

  def contains_upper_case_letter
    pattern = /[A-Z]/
    errors.add(:password, "Must contain an upper case letter") unless pattern.match?(password)
  end

  def contains_digit
    pattern = /\d/
    errors.add(:password, "Must contain a digit") unless pattern.match?(password)
  end

  def contains_symbol
    pattern = /[^\w\d]/
    errors.add(:password, "Must contain a symbol") unless pattern.match?(password)
  end
end
