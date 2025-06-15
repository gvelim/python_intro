# Import the `calculator` module here
import calculator

calc = calculator.Calculator()
for i in range(100):
    # Use the Calculator method `add` to add `i` to the current value.
    calc.add(i)

print(calc.get_current())




