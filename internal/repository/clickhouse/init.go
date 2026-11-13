package clickhouse

import (
	"context"
	"fmt"
	"net"
	"time"

	"project/internal/config"

	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
)

func New(cfg *config.ClickHouseConfig) (driver.Conn, error) {
	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{net.JoinHostPort(cfg.Host, cfg.Port)},
		Auth: clickhouse.Auth{Database: cfg.DBName, Username: cfg.User, Password: cfg.Password},
	})
	if err != nil {
		return nil, fmt.Errorf("clickhouse.NewClickHouseConnect.open: %w", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := conn.Ping(ctx); err != nil {
		_ = conn.Close()
		return nil, fmt.Errorf("clickhouse.NewClickHouseConnect.ping: %w", err)
	}
	return conn, nil
}
