package rabbitmq

import (
	"fmt"
	"net"
	"net/url"
	"time"

	"project/internal/config"

	amqp "github.com/rabbitmq/amqp091-go"
)

func New(cfg *config.RabbitMQConfig) (*amqp.Connection, error) {
	address := &url.URL{Scheme: "amqp", User: url.UserPassword(cfg.User, cfg.Password), Host: net.JoinHostPort(cfg.Host, cfg.Port)}
	conn, err := amqp.DialConfig(address.String(), amqp.Config{Dial: amqp.DefaultDial(5 * time.Second)})
	if err != nil {
		return nil, fmt.Errorf("rabbitmq.NewRabbitMQConnect.dial: %w", err)
	}
	return conn, nil
}
