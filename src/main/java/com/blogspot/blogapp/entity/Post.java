package com.blogspot.blogapp.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import com.blogspot.blogapp.enums.Poststatus;

@Entity
@Table(name="posts")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Post extends BaseEntity{

    @Column(nullable = false,length = 255)
    private String title;

    @Column(nullable = false, unique = true, length = 255)
    private String slug;                        // ← SEO url e.g. "my-first-post"

    @Column(columnDefinition = "LONGTEXT",nullable = false)
    private String content;

    @Column(name = "thumbnail_url", length = 500)
    private String thumbnailUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private Poststatus status = Poststatus.DRAFT; // ← default to DRAFT on creation

    @Column(name = "view_count", nullable = false)
    @Builder.Default
    private int viewCount = 0;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;           // ← set when status → PUBLISHED

    @ManyToOne(fetch = FetchType.LAZY)           // ← LAZY: don't load user unless needed
    @JoinColumn(name = "author_id", nullable = false)
    private User author;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")           // ← nullable: post can have no category
    private Category category;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "post_tags",
            joinColumns = @JoinColumn(name = "post_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    @Builder.Default
    private Set<Tag> tags = new HashSet<>();
}
