#include <iostream>
#include <boost/asio.hpp>
#include <string>
#include <thread>

int main()
{
    // 串口参数
    std::string portName = "/dev/ttyUSB1";  // 串口设备名称
    unsigned int baudRate = 115200;           // 波特率

    try
    {
        // 创建串口对象
        boost::asio::io_service io;
        boost::asio::serial_port port(io, portName);

        // 设置串口参数
        port.set_option(boost::asio::serial_port_base::baud_rate(baudRate));
        port.set_option(boost::asio::serial_port_base::character_size(8));
        port.set_option(boost::asio::serial_port_base::parity(boost::asio::serial_port_base::parity::none));
        port.set_option(boost::asio::serial_port_base::stop_bits(boost::asio::serial_port_base::stop_bits::one));
        port.set_option(boost::asio::serial_port_base::flow_control(boost::asio::serial_port_base::flow_control::none));

        for(int i=0; i<8; i++) {

            // 发送数据
            // std::string sendData = "Hello FPGA!";
            boost::asio::write(port, boost::asio::buffer(std::to_string(i)));
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }

        // 关闭串口
        port.close();

        std::cout << "数据已成功发送至 FPGA" << std::endl;
    }
    catch (std::exception& e)
    {
        std::cerr << "发生异常：" << e.what() << std::endl;
    }

    return 0;
}