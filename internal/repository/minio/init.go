package minio

import (
	"context"
	"fmt"
	"net"
	"time"

	"project/internal/config"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

func New(cfg *config.MinioConfig) (*minio.Client, error) {
	client, err := minio.New(net.JoinHostPort(cfg.Host, cfg.Port), &minio.Options{Creds: credentials.NewStaticV4(cfg.User, cfg.Password, ""), Secure: cfg.UseSSL})
	if err != nil {
		return nil, fmt.Errorf("minio.NewMinioClient.createClient: %w", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	exists, err := client.BucketExists(ctx, cfg.BucketName)
	if err != nil {
		return nil, fmt.Errorf("minio.NewMinioClient.checkBucket: %w", err)
	}
	if !exists {
		if err := client.MakeBucket(ctx, cfg.BucketName, minio.MakeBucketOptions{}); err != nil {
			return nil, fmt.Errorf("minio.NewMinioClient.createBucket: %w", err)
		}
	}
	return client, nil
}
