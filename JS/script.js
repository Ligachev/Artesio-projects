alert("It works!");

for (var i = 10; i <= 20; i++) {
  console.log(i);
}

for (var i = 10; i <= 20; i++) {
  console.log(i * i);
}

var sum = 0;
for (var i = 10; i <= 20; i++) {
  sum += i;
}
console.log(sum);

var x1, x2;
function buttonClick() {
  x1 = document.getElementById("x1").value;
  x2 = document.getElementById("x2").value;
  var rad = document.getElementsByName("r1");
  var resultDiv = document.getElementById("result");

  if (x1 === "" || x2 === "") {
    alert("Поля x1 и x2 должны быть заполнены");
  } else {
    var numberOfx1 = parseInt(x1);
    var numberOfx2 = parseInt(x2);
    if (Number.isNaN(numberOfx1) || Number.isNaN(numberOfx2)) {
      alert("В поля x1 и x2 должны быть введены числовые значения");
    } else {
      for (var i = 0; i < rad.length; i++) {
        if (rad[i].checked) {
          if (rad[i].value == "Sum") {
            resultDiv.innerHTML = "";
            //   resultDiv.append("x1: " + x1 + ", x2: " + x2 + ";");
            //   resultDiv.append(" x1 + x2 = " + (numberOfx1 + numberOfx2));
            var sum = 0;
            for (var i = numberOfx1; i <= numberOfx2; i++) {
              sum += i;
            }
            resultDiv.append(
              "Сумма значений от x1 = " +
                numberOfx1 +
                " до х2 = " +
                numberOfx2 +
                " составляет " +
                sum
            );
          } else if (rad[i].value == "Multiplication") {
            resultDiv.innerHTML = "";
            var multiplication = 1;
            for (var i = numberOfx1; i <= numberOfx2; i++) {
              multiplication *= i;
            }
            resultDiv.append(
              "Произведение значений от x1 = " +
                numberOfx1 +
                " до х2 = " +
                numberOfx2 +
                " составляет " +
                multiplication
            );
          } else if (rad[i].value == "PrimeNumbers") {
            resultDiv.innerHTML = "";
            resultDiv.append(
              "Простые числа в диапазоне от x1 = " +
                numberOfx1 +
                " до х2 = " +
                numberOfx2 +
                " это: "
            );
            prime: for (var j = numberOfx1; j < numberOfx2; j++) {
              if (j === 1) {
                continue;
              }
              for (var k = 2; k <= j; k++) {
                if (j % k === 0 && j != k) continue prime;
              }
              resultDiv.append(j + "; ");
            }
          }
        }
      }
    }
  }
}

function inputClear() {
  if (x1 != "" || x2 != "") {
    document.getElementById("x1").value = "";
    document.getElementById("x2").value = "";
  }
}
