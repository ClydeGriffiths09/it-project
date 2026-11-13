package redis

import (
	"context"
	"fmt"
	"net"
	"time"

	"project/internal/config"

	"github.com/redis/go-redis/v9"
)

func NewRedisClient(cfg *config.RedisConfig) (*redis.Client, error) {
	client := redis.NewClient(&redis.Options{Addr: net.JoinHostPort(cfg.Host, cfg.Port), Password: cfg.Password})
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := client.Ping(ctx).Err(); err != nil {
		_ = client.Close()
		return nil, fmt.Errorf("redis.NewRedisClient.ping: %w", err)
	}
	return client, nil
}
