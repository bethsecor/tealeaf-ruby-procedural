# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(number)
  number.to_f.to_s == number || number.to_i.to_s == number
end

def operation_to_message(operation)
  word = case operation
         when 'add'
           'Adding'
         when 'subtract'
           'Subtracting'
         when 'multiply'
           'Multiplying'
         when 'divide'
           'Dividing'
         end
  #other code if necessary
  word
end

prompt MESSAGES['welcome']
name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt MESSAGES['valid_name']
  else
    break
  end
end

prompt "Hi #{name.capitalize}!"

loop do
  number1 = ''
  loop do
    prompt MESSAGES['number_prompt']
    number1 = gets.chomp
    if valid_number?(number1)
      number1 = Float(number1)
      break
    else
      prompt MESSAGES['invalid_number']
    end
  end

  number2 = ''
  loop do
    prompt MESSAGES['number_prompt']
    number2 = gets.chomp
    if valid_number?(number2)
      number2 = Float(number2)
      break
    else
      prompt MESSAGES['invalid_number']
    end
  end

  prompt "You gave #{number1} and #{number2}."

  operation_prompt = <<-MSG
  What operation would you like to perform?
  - add
  - subtract
  - multiply
  - divide
  MSG

  prompt operation_prompt

  operation = ''
  loop do
    operation = gets.chomp.downcase

    if %w(add subtract multiply divide).include?(operation)
      break
    else
      prompt MESSAGES['invalid_operation']
    end
  end

  prompt "#{operation_to_message(operation)} the two numbers..."

  result = case operation
           when "add"
             number1 + number2
           when "subtract"
             number1 - number2
           when "multiply"
             number1 * number2
           when "divide"
             number1.to_f / number2.to_f
           end

  prompt ""
  prompt "The result is #{result}."
  prompt MESSAGES['another_calc']
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt MESSAGES['goodbye']
