package com.blogspot.blogapp.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="comments")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class Comment extends BaseEntity{

    @Column(nullable = false, columnDefinition = "Text")
    private String body;

    @Column(name="is_approved", nullable = false)
    @Builder.Default
    private boolean approved = true;

    // ─── Relationships ────────────────────────────────────────────────
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")             // ← null = top-level, non-null = reply
    private Comment parent;                      // ← self-reference for nested comments
}
