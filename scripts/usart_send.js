const {SerialPort} = require('serialprot');

SerialPort.list().then((ports) => {
    console.log(ports); // 打印串口列表
}).catch((err) => {
    console.log(err);
});


const tangnano = new SerialPort({
    path: 'COM84',
    BaudRate: 115200,
})

let cnt = 0;

function send_number() {
    cnt++;
    tangnano.write(Buffer.from([cnt]));

}

setInterval(send_number, 100);