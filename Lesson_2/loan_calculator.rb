# loan_calculator.rb

require 'yaml'
MESSAGES = YAML.load_file('loan_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(number)
  number.to_f.to_s == number || number.to_i.to_s == number
end

def valid_apr?(number)
  Float(number) > 1
end

prompt MESSAGES['welcome']
name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt MESSAGES['invalid_name']
  else
    break
  end
end

prompt "Hi #{name.capitalize}!"

loop do
  loan_amount = ''
  loan_amount_n = ''
  loop do
    prompt MESSAGES['loan_prompt']
    loan_amount = gets.chomp
    if valid_number?(loan_amount)
      loan_amount_n = Float(loan_amount)
      break
    else
      prompt MESSAGES['invalid_loan']
    end
  end

  apr = ''
  apr_n = ''
  loop do
    prompt MESSAGES['apr_prompt']
    apr = gets.chomp
    if valid_apr?(apr)
      apr_n = Float(apr)
      break
    else
      prompt MESSAGES['invalid_apr']
    end
  end

  monthly_rate = (apr_n / 100) / 12

  duration_years = ''
  duration_years_n = ''
  loop do
    prompt MESSAGES['duration_prompt']
    duration_years = gets.chomp
    if valid_number?(duration_years)
      duration_years_n = Integer(duration_years)
      break
    else
      prompt MESSAGES['invalid_duration']
    end
  end

  duration_months = duration_years_n * 12

  payment = loan_amount_n * (monthly_rate * (1 + monthly_rate)**duration_months) / ((1 + monthly_rate)**duration_months - 1)
  prompt "Your fixed monthly payment is $#{(payment * 100).round / 100.0} required
  to fully amortize a loan of $#{loan_amount}
  over a term of #{(duration_years)} months
  at a monthly interest rate of #{(monthly_rate * 10_000).round / 100.0}%."
  # could also use format('%0.2f',payment)

  prompt MESSAGES['another_calc']
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt MESSAGES['goodbye']
